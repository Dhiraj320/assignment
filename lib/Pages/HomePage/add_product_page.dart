import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopify/Storage/shared_preference.dart';


class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image Selected')),
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Image not Selected')),
      );
      }
    });
  }

  void addProduct() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Price are required')),
      );
      return;
    }

    SharedPreferencesHelper.addProduct({
      'name': nameController.text,
      'price': double.parse(priceController.text),
      'image': _image?.path,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              
              const SizedBox(height: 20),
                isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: addProduct,
                      child: const Text('Add'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}