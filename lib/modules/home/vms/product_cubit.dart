import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:supa_app/modules/home/services/product_service.dart';

class ProductState {
  final List<dynamic> products;
  final bool isLoading;
  final String? error;

  ProductState({
    required this.products,
    required this.isLoading,
    this.error,
  });

  ProductState copyWith({
    List<dynamic>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductCubit extends Cubit<ProductState> {
  final ProductService productService;

  ProductCubit(this.productService)
      : super(ProductState(products: [], isLoading: true)) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService.fetchProducts();
      emit(state.copyWith(products: fetchedProducts, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> searchProduct(String query) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      if (query.isEmpty) {
        fetchProducts();
      } else {
        final searchResults = await productService.searchProducts(query);
        emit(state.copyWith(products: searchResults, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteProduct(int productId, context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation!'),
          content: Text('Are you sure want to delete the product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await productService.deleteProduct(productId);
        fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Продукт удалён успешно!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении продукта: $e')),
        );
      }
    }
  }
}
