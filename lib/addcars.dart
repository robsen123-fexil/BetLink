// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideswift/carlist.dart';

final _firestore = FirebaseFirestore.instance;

class AddCars extends StatefulWidget {
  const AddCars({super.key});

  @override
  State<AddCars> createState() => _AddCarsState();
}

class _AddCarsState extends State<AddCars> {
  final TextEditingController modelTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController placeTextController = TextEditingController();
  final TextEditingController seatsTextController = TextEditingController();

  String carModel = '';
  String? seats;
  String? carPrice;
  String carPlace = '';
  String? downloadUrl;
  File? _selectedImage;

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Future<void> pickim() async {
  //   final pick = ImagePicker();
  //    final pikced =await  pick.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pikced != null) {
  //     File selectedimage = File(pikced.path);
  //     }
  //   });
  // }

  // Method to upload image to Firebase Storage and get the URL
  Future<String?> _uploadImageToStorage() async {
    if (_selectedImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_selectedImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Method to add car details to Firestore, including image URL
  Future<void> _addCar() async {
    carModel = modelTextController.text;
    carPrice = priceTextController.text;
    carPlace = placeTextController.text;
    seats = seatsTextController.text;

    if (carModel.isNotEmpty && carPrice != null && carPlace.isNotEmpty) {
      try {
        downloadUrl = await _uploadImageToStorage(); // Upload image and get URL

        await _firestore.collection('cars').add({
          'model': carModel,
          'price': carPrice,
          'place': carPlace,
          'seats': seats,
          'imageUrl': downloadUrl ?? '', // Save image URL or empty string
        });
        print("Car successfully added");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Carlist()),
        );
      } catch (e) {
        print("Car was not added successfully: $e");
      }
    } else {
      print("Please fill in all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Add Car"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Display picked image preview if available
                _selectedImage != null
                    ? Image.file(_selectedImage!,
                        height: 150, fit: BoxFit.cover)
                    : Container(
                        height: 150,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 238, 234, 234),
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                SizedBox(height: 10),
                // Button to pick an image
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text("Select Image"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: modelTextController,
                  style: TextStyle(color: Colors.pink),
                  decoration: InputDecoration(labelText: 'Car Model'),
                ),
                TextField(
                  controller: priceTextController,
                  style: TextStyle(color: Colors.blue),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Car Price'),
                ),
                TextField(
                  controller: seatsTextController,
                  style: TextStyle(color: Colors.blue),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Seats'),
                ),
                TextField(
                  controller: placeTextController,
                  style: TextStyle(color: Colors.yellow),
                  decoration: InputDecoration(labelText: 'Car Place'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addCar,
                  child: Text("Add Car"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
