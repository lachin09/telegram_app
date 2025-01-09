import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supa_app/modules/services/supa_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  final picker = ImagePicker();
  bool isLoading = false;

  final productService = Modular.get<ProductService>();

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> saveProduct() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final description = descriptionController.text.trim();

    if (name.isEmpty || price <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fill fields correctly!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl;

    try {
      if (selectedImage != null) {
        imageUrl = await productService.uploadImage(selectedImage!);
        if (imageUrl == null) {
          throw Exception('Image uploading error');
        }
      }

      await productService.saveProduct(
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        selectedImage = null;
      });

      Modular.to.pop();
    } catch (e) {
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
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: selectedImage == null
                      ? Center(child: Text('Tap to choose an image'))
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(selectedImage!, fit: BoxFit.cover),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedImage = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: saveProduct,
                      child: Text('Save Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
