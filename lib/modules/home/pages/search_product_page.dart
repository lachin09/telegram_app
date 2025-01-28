import 'package:flutter/material.dart';
import 'package:supa_app/modules/home/components/product_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
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
      // Step 1: Search products by name
      final nameResponse = await Supabase.instance.client
          .from("products")
          .select("*")
          .ilike("name", "%$query%");

      // Step 2: Find all products in the same categories as the name search results
      final categoryIds = nameResponse
          .map((product) => product['category_id'])
          .toSet()
          .toList();

      List<dynamic> categoryResponse = [];

      // Only fetch products by category if we have some category ids
      if (categoryIds.isNotEmpty) {
        final categoriesQuery = categoryIds.map((categoryId) {
          return "category_id.eq.$categoryId";
        }).join('&');

        // Fetch products that match any of the category ids found in the first query
        categoryResponse = await Supabase.instance.client
            .from("products")
            .select("*")
            .filter('category_id', 'in', categoryIds); // Use filter with 'in'
      }

      // Combine both the name search and category search results
      final allProducts = [...nameResponse, ...categoryResponse];

      // Remove duplicates
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
            // Show loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            // Show error message
            if (_error != null)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Display product list
            Expanded(
              child: _products.isEmpty && !_isLoading
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ProductCard(
                          onDelete: null,
                          imageUrl: product['image_url'],
                          name: product['name'] ?? 'No Name',
                          price: '${product['price'] ?? '0.0'}',
                          category: "${product['category_id'] ?? '0.0'}",
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
