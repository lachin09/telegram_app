import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final SupabaseClient supabase;

  ProductService(this.supabase);

  Future<String?> uploadImage(File imageFile) async {
    final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final response = await supabase.storage.from('images').upload(
          uniqueFileName,
          imageFile,
        );

    if (response.isNotEmpty) {
      return supabase.storage.from('images').getPublicUrl(uniqueFileName);
    } else {
      print('Image uploading error.');
      return null;
    }
  }

  Future<void> saveProduct({
    required String name,
    required double price,
    required String description,
    String? imageUrl,
  }) async {
    final response = await supabase.from('products').insert({
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'user_id': supabase.auth.currentUser?.id,
    });

    if (response.error == null) {
      print('product added succesfuly!');
    } else {
      print('Product addding error: ${response.error?.message}');
      throw Exception('Product addding error.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await supabase.from('products').select('*');

    if (response.isNotEmpty) {
      return List<Map<String, dynamic>>.from(response as List);
    } else {
      print('Product fetching error: ');
      throw Exception('Product fetching error.');
    }
  }

  Future<void> signUpWithEmail(
      {required String email, required String password}) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      print("Регистрация успешна! Пользователь: ${response.user!.email}");
    } else {
      print("Ошибка регистрации: ");
    }
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session != null) {
      print("Вход успешен! Токен: ${response.session!.accessToken}");
    } else {
      print("Ошибка входа: ${response.session!.isExpired}");
    }
  }

  Future<void> deleteProduct({required String productId}) async {
    final response =
        await supabase.from('products').delete().eq('id', productId);

    if (response.error == null) {
      print('Product deleted successfully!');
    } else {
      print('Error deleting product: ${response.error?.message}');
      throw Exception('Error deleting product');
    }
  }
}
