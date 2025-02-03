import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/home/services/product_service.dart';
import 'package:supa_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final picker = ImagePicker();
  bool isLoading = false;
  PlatformFile? _imageFile;
  final productService = Modular.get<ProductService>();
  final ImageService imageService = Modular.get<ImageService>();
  bool isAuth = Supabase.instance.client.auth.currentUser != null;

  Future<void> pickImageWeb() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> saveProduct() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final description = descriptionController.text.trim();
    final categoryId = categoryController.text.trim();

    if (name.isEmpty || price <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill fields correctly!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl;

    try {
      if (_imageFile != null) {
        imageUrl = await imageService.uploadImage(_imageFile!);
        if (imageUrl == null) {
          throw Exception('Image uploading error');
        }
      }

      await productService.saveProduct(
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl,
          categoryId: categoryId);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      categoryController.clear();
      setState(() {
        _imageFile = null;
      });

      Modular.to.pop(true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: isAuth
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: pickImageWeb,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _imageFile == null
                              ? const Center(
                                  child: Text('Tap to choose an image'))
                              : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(
                                        Uint8List.fromList(_imageFile!.bytes!)),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _imageFile = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: saveProduct,
                              child: const Text('Save Product'),
                            ),
                    ],
                  ),
                ),
              )
            : Center(
                child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("log in to add product!!"),
                    TextButton(
                        onPressed: () {
                          Modular.to.pushNamed(
                              Routes.login.getRoute(Routes.login.signUp));
                        },
                        child: const Text("tap to register"))
                  ],
                ),
              )));
  }
}
