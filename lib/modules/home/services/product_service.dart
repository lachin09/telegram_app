import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IProductService {
  Future<void> saveProduct(
      {required String name,
      required double price,
      required String description,
      List<String>? imageUrls,
      required String categoryId});

  Future<List<Map<String, dynamic>>> fetchProducts();
  Future<Map<String, dynamic>?> fetchProductDetails(int productId);
  Future<void> deleteProduct(int productId);
  Future<List<dynamic>> searchProducts(String query);
}

abstract class IImageService {
  Future<List<String?>> uploadImages(List<PlatformFile> imageFiles);
}

class ProductService implements IProductService {
  final SupabaseClient supabase;

  ProductService(this.supabase);

  @override
  Future<void> saveProduct(
      {required String name,
      required double price,
      required String description,
      List<String?>? imageUrls,
      required String categoryId}) async {
    final response = await supabase.from('products').insert({
      'name': name,
      'price': price,
      'description': description,
      'image_urls': imageUrls ?? [],
      'user_id': supabase.auth.currentUser?.id,
      "category_id": categoryId
    });

    if (response.error != null) {
      print('Product adding error: ${response.error?.message}');
      throw Exception('Product adding error.');
    }
    print('Product added successfully!');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await supabase.from('products').select('*');
    print("Raw response: $response");
    if (response.isEmpty) {
      throw Exception('Product fetching error.');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> fetchProductDetails(int productId) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('id', productId)
          .maybeSingle();

      return response;
    } catch (e) {
      print("Ошибка при получении продукта: $e");
      return null;
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      final response =
          await supabase.from('products').delete().eq('id', productId).select();
      if ((response as List).isEmpty) {
        throw Exception('Product not found');
      }
      print('Product deleted successfully!');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await supabase
          .from("products")
          .select("*")
          .textSearch("fts", query, config: "simple");

      if (response.isEmpty) {
        throw Exception('No products found');
      }

      return response;
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }
}

class ImageService implements IImageService {
  final SupabaseClient supabase;

  ImageService(this.supabase);

  @override
  Future<List<String>> uploadImages(List<PlatformFile> imageFiles) async {
    List<String> imageUrls = [];

    for (var imageFile in imageFiles) {
      final uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final fileBytes = imageFile.bytes!;

      print("Uploading file: $uniqueFileName");

      final path = await supabase.storage
          .from("images")
          .uploadBinary(uniqueFileName, fileBytes);

      if (path != null) {
        final publicUrl =
            'https://ptekcinizrbjxkrxwaqf.supabase.co/storage/v1/object/public/images/$uniqueFileName';

        print("Uploaded URL: $publicUrl");
        imageUrls.add(publicUrl);
      } else {
        print("Upload failed for: $uniqueFileName");
      }
    }

    print("Final image URLs: $imageUrls");
    return imageUrls;
  }
}
