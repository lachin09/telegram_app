// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProductService {
//   final SupabaseClient supabase;

//   ProductService(this.supabase);

//   Future<String?> uploadImage(PlatformFile imageFile) async {
//     final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

//     Uint8List fileBytes = imageFile.bytes!;

//     final response = await supabase.storage.from('images').uploadBinary(
//           uniqueFileName,
//           fileBytes,
//         );

//     if (response.isNotEmpty) {
//       return supabase.storage.from('images').getPublicUrl(uniqueFileName);
//     } else {
//       print('Image uploading error.');
//       return null;
//     }
//   }

//   Future<void> saveProduct(
//       {required String name,
//       required double price,
//       required String description,
//       String? imageUrl,
//       required String category_id}) async {
//     final response = await supabase.from('products').insert({
//       'name': name,
//       'price': price,
//       'description': description,
//       'image_url': imageUrl,
//       'user_id': supabase.auth.currentUser?.id,
//       "category_id": category_id
//     });

//     if (response.error == null) {
//       print('product added succesfuly!');
//     } else {
//       print('Product addding error: ${response.error?.message}');
//       throw Exception('Product addding error.');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchProducts() async {
//     final response = await supabase.from('products').select('*');

//     if (response.isNotEmpty) {
//       return List<Map<String, dynamic>>.from(response as List);
//     } else {
//       print('Product fetching error: ');
//       throw Exception('Product fetching error.');
//     }
//   }

//   Future<Map<String, dynamic>?> fetchProductDetails(
//       {required int productId}) async {
//     final response =
//         await supabase.from('products').select().eq('id', productId).single();

//     if (response != null) {
//       return response;
//     } else {
//       throw Exception('Product not found');
//     }
//   }

//   Future<void> deleteProduct({required dynamic productId}) async {
//     try {
//       final response =
//           await supabase.from('products').delete().eq('id', productId).select();

//       if ((response as List).isEmpty) {
//         print('No product found with the given ID.');
//         throw Exception('Product not found');
//       }

//       print('Product deleted successfully!');
//     } catch (e) {
//       print('Unexpected error: $e');
//       throw Exception('Unexpected error: $e');
//     }
//   }

//   Future<List<dynamic>> searchProducts(String query) async {
//     try {
//       final response = await supabase
//           .from("products")
//           .select("*")
//           .textSearch("fts", query, config: "simple");

//       if (response.isEmpty) {
//         throw Exception('Ничего не найдено');
//       }

//       return response;
//     } catch (e) {
//       throw Exception('Ошибка поиска: $e');
//     }
//   }

//   Future<void> signUpWithEmail(
//       {required String email, required String password}) async {
//     final response = await supabase.auth.signUp(
//       email: email,
//       password: password,
//     );

//     if (response.user != null) {
//       print("Регистрация успешна! Пользователь: ${response.user!.email}");
//     } else {
//       print("Ошибка регистрации: ");
//     }
//   }

//   Future<void> signInWithEmail(
//       {required String email, required String password}) async {
//     final response = await supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );

//     if (response.session != null) {
//       print("Вход успешен! Токен: ${response.session!.accessToken}");
//     } else {
//       print("Ошибка входа: ${response.session!.isExpired}");
//     }
//   }
// }
