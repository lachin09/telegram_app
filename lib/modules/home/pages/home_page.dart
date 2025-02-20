import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/components/drawer.dart';
import 'package:supa_app/modules/home/components/product_list_view.dart';
import 'package:supa_app/modules/home/vms/product_cubit.dart';
import 'package:supa_app/routes/routes.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => Modular.get<ProductCubit>(),
      child: Scaffold(
        drawer: drawer,
        backgroundColor: const Color.fromARGB(255, 220, 216, 216),
        appBar: AppBar(
          title: const Text('H A L A L   S H O P'),
          actions: [
            IconButton(
              onPressed: () {
                Modular.to.pushNamed(Routes.home.getRoute(Routes.home.search));
              },
              icon: const Icon(Icons.search_sharp),
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            final productCubit = Modular.get<ProductCubit>();

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text('Ошибка: ${state.error}'));
            }

            if (state.products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (screenWidth ~/ 200).clamp(2, 4),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: state.products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = state.products[index];
                final imageUrls = (product['image_urls'] as List<dynamic>?)
                        ?.map((url) => url.toString())
                        .toList() ??
                    [];
                final name = product['name'] ?? 'No Name';
                final price = product['price']?.toString() ?? '0.0';
                final category =
                    product['category_id']?.toString() ?? 'No Category';
                final description = product['description'] ?? 'No Description';
                final productId = product['id'];

                return ProductCard(
                  onDelete: () {
                    productCubit.deleteProduct(productId, context);
                  },
                  imageUrl: imageUrls.isNotEmpty
                      ? imageUrls
                          .where((url) => url != null && url.isNotEmpty)
                          .toList()
                      : ['https://via.placeholder.com/150'],
                  name: name,
                  price: price,
                  category: category,
                  description: description,
                  productId: productId,
                  ownerId: product['user_id'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
