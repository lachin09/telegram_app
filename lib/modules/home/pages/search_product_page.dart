import 'package:flutter/material.dart';
import 'package:supa_app/modules/home/components/product_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  ProductSearchPageState createState() => ProductSearchPageState();
}

class ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;

  Future<void> searchProducts(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final nameResponse = await Supabase.instance.client
          .from("products")
          .select("*")
          .ilike("name", "%$query%");

      final categoryIds = nameResponse
          .map((product) => product['category_id'])
          .toSet()
          .toList();

      List<dynamic> categoryResponse = [];

      if (categoryIds.isNotEmpty) {
        categoryIds.map((categoryId) {
          return "category_id.eq.$categoryId";
        }).join('&');

        categoryResponse = await Supabase.instance.client
            .from("products")
            .select("*")
            .filter('category_id', 'in', categoryIds); // Use filter with 'in'
      }

      final allProducts = [...nameResponse, ...categoryResponse];

      final uniqueProducts = allProducts.toSet().toList();

      setState(() {
        _products = uniqueProducts;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      searchProducts(query);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            if (_error != null)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Expanded(
              child: _products.isEmpty && !_isLoading
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ProductCard(
                          imageUrl: product['image_urls'],
                          name: product['name'],
                          price: product['price'].toString(),
                          description: product['description'],
                          category: product['category_id'].toString(),
                          onDelete: () {},
                          productId: product['id'],
                          ownerId: product['user_id'],
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
