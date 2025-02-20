// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';

// import 'package:supa_app/modules/home/components/product_list_view.dart';
// import 'package:supa_app/modules/home/services/product_service.dart';

// import 'package:supa_app/routes/routes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   ProductListScreenState createState() => ProductListScreenState();
// }

// class ProductListScreenState extends State<ProductListScreen> {
//   final productService = Modular.get<ProductService>();
//   List<dynamic> products = [];
//   bool isLoading = true;
//   final user = Supabase.instance.client.auth.currentUser;
//   bool isAuth = Supabase.instance.client.auth.currentUser != null;
//   String? error;

//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> searchProduct(String query) async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//     try {
//       if (query.isEmpty) {
//         fetchProducts();
//       } else {
//         final searchProducts = await productService.searchProducts(query);
//         setState(() {
//           products = searchProducts;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchProducts() async {
//     try {
//       final fetchedProducts = await productService.fetchProducts();
//       setState(() {
//         products = fetchedProducts;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка загрузки продуктов: $e')),
//       );
//     }
//   }

//   Future<void> deleteProduct(int productId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Confirmation!'),
//           content: Text('Are you sure want to delete the product?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmed == true) {
//       try {
//         await productService.deleteProduct(productId);
//         await fetchProducts();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Продукт удалён успешно!')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Ошибка при удалении продукта: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 220, 216, 216),
//       appBar: AppBar(
//         title: Text('H A L A L   S H O P'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Modular.to.pushNamed(Routes.home.getRoute(Routes.home.search));
//               },
//               icon: Icon(Icons.search_sharp))
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(child: Text("O N L I N E   S H O P ")),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text("S E T T I N G S"),
//               trailing: Icon(Icons.forward),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.category_outlined),
//               title: Text("C A T E G O R I E S"),
//               trailing: Icon(Icons.forward),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text("L O G O U T"),
//               trailing: Icon(Icons.forward),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.favorite),
//               title: Text("R A T E   US"),
//               trailing: Icon(Icons.forward),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 300,
//               child: Column(
//                 children: [
//                   const Text(
//                     "Burada sizin reklam ola biler!!",
//                     style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                   ),
//                   isAuth
//                       ? TextButton(
//                           onPressed: () {
//                             Modular.to.pushNamed(
//                                 Routes.home.getRoute(Routes.home.products));
//                           },
//                           child: const Text(
//                             "Tap to Add product",
//                           ))
//                       : const Text("Sign in to add prodcut")
//                 ],
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : products.isEmpty
//                       ? const Center(child: Text('No products available'))
//                       : GridView.builder(
//                           padding: const EdgeInsets.all(8),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: (screenWidth ~/ 200).clamp(2, 4),
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                             childAspectRatio: 0.75,
//                           ),
//                           itemCount: products.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final product = products[index];
//                             return ProductCard(
//                               onDelete: () {
//                                 deleteProduct(product['id']);
//                               },
//                               imageUrl: product['image_url'],
//                               name: product['name'] ?? 'No Name',
//                               price: '${product['price'] ?? '0.0'}',
//                               category: '${product['category_id'] ?? '0.0'}',
//                               description:
//                                   product['description'] ?? 'No Description',
//                               productId: product['id'],
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       title: const Text('Search Products'),
//       content: SizedBox(
//         height: 150.h,
//         child: Column(
//           children: [
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Enter product name...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     searchProduct(searchController.text);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//               onSubmitted: (query) {
//                 searchProduct(query);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );
