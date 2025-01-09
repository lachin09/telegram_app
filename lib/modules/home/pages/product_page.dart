import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/services/supa_service.dart';
import 'package:supa_app/routes/routes.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final productService = Modular.get<ProductService>();
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await productService.deleteProduct(productId: productId);

      await fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Продукт удалён успешно!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении продукта: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products list'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: SizedBox(
                          height: 400,
                          width: 300,
                          child: product['image_url'] != null
                              ? Image.network(
                                  product['image_url'],
                                  // width: 50,
                                  // height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image_not_supported,
                                  size: 100,
                                ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'name:${product['name']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text('price:${product['price']} USD'),
                          Text('description:${product['description']} '),
                        ],
                      )
                    ],
                  ),
                );

                // ListTile(
                //   title: Text(product['name']),
                //   subtitle: Text('${product['price']} USD'),
                //   leading: product['image_url'] != null
                //       ? Image.network(
                //           product['image_url'],
                //           width: 50,
                //           height: 50,
                //           fit: BoxFit.cover,
                //         )
                //       : Icon(Icons.image_not_supported),
                //   trailing: IconButton(
                //     icon: Icon(Icons.delete),
                //     onPressed: () {
                //       deleteProduct(product['id']);
                //     },
                //   ),
                // );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed(Routes.home.getRoute(Routes.home.products));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
