import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:supa_app/modules/services/supa_service.dart';
import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductListScreen extends StatefulWidget {
  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final productService = Modular.get<ProductService>();
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  final user = Supabase.instance.client.auth.currentUser;
  bool isAuth = Supabase.instance.client.auth.currentUser != null;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки продуктов: $e')),
      );
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 216, 216),
      appBar: AppBar(
        title: Text('Products list'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search_sharp))],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("O N L I N E   S H O P ")),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("S E T T I N G S"),
              trailing: Icon(Icons.forward),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("L O G O U T"),
              trailing: Icon(Icons.forward),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("R A T E   US"),
              trailing: Icon(Icons.forward),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  const Text(
                    "Burada sizin reklam ola biler!!",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  isAuth
                      ? TextButton(
                          onPressed: () {
                            Modular.to.pushNamed(
                                Routes.home.getRoute(Routes.home.products));
                          },
                          child: const Text(
                            "Tap to Add product",
                          ))
                      : const Text("Sign in to add prodcut")
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : products.isEmpty
                      ? const Center(child: Text('No products available'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (screenWidth ~/ 200).clamp(2, 4),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = products[index];
                            return ProductCard(
                              onDelete: () {
                                deleteProduct(product['id']);
                              },
                              imageUrl: product['image_url'],
                              name: product['name'] ?? 'No Name',
                              price: '${product['price'] ?? '0.0'}',
                              description:
                                  product['description'] ?? 'No Description',
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String price;
  final String description;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Name: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          color: Colors.amber,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Price: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: price,
                        style: TextStyle(color: Colors.amber),
                      ),
                      const TextSpan(
                        text: " USD",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
