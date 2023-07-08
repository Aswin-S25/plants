import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/ui/screens/widgets/custom_textfield.dart';
import 'package:uuid/uuid.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  State<AddPlant> createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  XFile _image = XFile('');
  String _imageUrl = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  final TextEditingController _plantDescriptionController =
      TextEditingController();

  final TextEditingController _plantCategoryController =
      TextEditingController();
  final TextEditingController _plantSizeController = TextEditingController();
  final TextEditingController _plantTemperatureController =
      TextEditingController();
  
  
  final TextEditingController _plantPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Plant",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextfield(
                      icon: Icons.grass_outlined,
                      obscureText: false,
                      hintText: "Plant Name",
                      controller: _plantNameController,
                    ),
                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.type_specimen_rounded,
                      obscureText: false,
                      hintText: "Plant Type",
                      controller: _plantTypeController,
                    ),

                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.description_outlined,
                      obscureText: false,
                      hintText: "Plant Description",
                      controller: _plantDescriptionController,
                    ),

                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.attach_money_outlined,
                      obscureText: false,
                      hintText: "Plant Price",
                      controller: _plantPriceController,
                      isPrice: true,
                    ),

                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.store_mall_directory,
                      obscureText: false,
                      hintText: "Category",
                      controller: _plantCategoryController,
                    ),

                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.category_outlined,
                      obscureText: false,
                      hintText: "small, medium, large",
                      controller: _plantSizeController,
                    ),

                    const SizedBox(height: 50),

                    CustomTextfield(
                      icon: Icons.bathroom_rounded,
                      obscureText: false,
                      hintText: "Temperature",
                      controller: _plantTemperatureController,
                    ),

                    const SizedBox(height: 50),

                    // Pick image button in green color
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: const Text(
                          "Pick Image",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Add plant button in green color
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          addPlant();
                        },
                        child: const Text(
                          "Add Plant",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = image;
        });
        log(_image.path);

        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          log('No user is currently signed in');
          return;
        }

        // Upload the selected image to Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('plants/${const Uuid().v4()}');
        UploadTask uploadTask = storageReference.putFile(File(_image.path));
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        log('Image uploaded to Firebase Storage: $imageUrl');
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      log('Image picking failed: $e');
    }
  }

  void addPlant() {
    if (_formKey.currentState!.validate()) {
      // Add plant to database
      String name = _plantNameController.text;
      String type = _plantTypeController.text;
      String description = _plantDescriptionController.text;
      String price = _plantPriceController.text;
      String category = _plantCategoryController.text;
      String size = _plantSizeController.text;
      String temperature = _plantTemperatureController.text;
      log(_imageUrl);

      FirebaseFirestore.instance.collection('plants').add({
        'name': name,
        'type': type,
        'description': description,
        'price': int.parse(price),
        'url' : _imageUrl,
        'category': category,
        'size': size,
        'temperature': temperature,
      }).then((DocumentReference document) async {
        // Get the ID of the added document
        String plantId = document.id;

        // Update the document with the image URL
        String imageUrl =
            ''; // Set the image URL obtained from Firebase Storage
        await document.update({'image': imageUrl});

        log('Plant added with ID: $plantId');
      }).catchError((error) {
        log('Error adding plant: $error');
      });
    }
  }
}
