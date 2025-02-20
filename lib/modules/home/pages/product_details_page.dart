import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/services/product_service.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductService productService = Modular.get<ProductService>();
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? error;
  int? productId;

  @override
  void initState() {
    super.initState();

    productId = Modular.args.data as int?;
    print("Received productId: $productId");

    if (productId == null) {
      setState(() {
        error = "Ошибка: productId отсутствует";
        isLoading = false;
      });
      return;
    }

    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final productDetails =
          await productService.fetchProductDetails(productId!);
      setState(() {
        product = productDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Error: $error')),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Not Found')),
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product!['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product!['image_urls'] is List &&
                (product!['image_urls'] as List).isNotEmpty)
              SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: (product!['image_urls'] as List).length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        (product!['image_urls'] as List<dynamic>)[index]
                            .toString(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
            SizedBox(height: 16),
            Text(
              product!['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${product!['price']}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${product!['category_id']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              product!['description'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
