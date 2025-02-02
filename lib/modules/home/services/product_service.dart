import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IProductService {
  Future<void> saveProduct(
      {required String name,
      required double price,
      required String description,
      String? imageUrl,
      required String categoryId});

  Future<List<Map<String, dynamic>>> fetchProducts();
  Future<Map<String, dynamic>?> fetchProductDetails(int productId);
  Future<void> deleteProduct(int productId);
  Future<List<dynamic>> searchProducts(String query);
}

abstract class IImageService {
  Future<String?> uploadImage(PlatformFile imageFile);
}

class ProductService implements IProductService {
  final SupabaseClient supabase;

  ProductService(this.supabase);

  @override
  Future<void> saveProduct(
      {required String name,
      required double price,
      required String description,
      String? imageUrl,
      required String categoryId}) async {
    final response = await supabase.from('products').insert({
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
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
    if (response.isEmpty) {
      throw Exception('Product fetching error.');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> fetchProductDetails(int productId) async {
    final response =
        await supabase.from('products').select().eq('id', productId).single();
    return response;
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
  Future<String?> uploadImage(PlatformFile imageFile) async {
    final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final fileBytes = imageFile.bytes!;

    final response = await supabase.storage.from('images').uploadBinary(
          uniqueFileName,
          fileBytes,
        );

    if (response.isEmpty) {
      throw Exception('Image upload failed');
    }

    return supabase.storage.from('images').getPublicUrl(uniqueFileName);
  }
}
