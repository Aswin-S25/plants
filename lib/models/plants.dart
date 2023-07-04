import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/ui/screens/widgets/plant_widget.dart';

import '../ui/screens/detail_page.dart';

class Plant {
  late  int plantId;
  final int price;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String description;
  bool isSelected;

  Plant({
    required this.plantId,
    required this.price,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.description,
    required this.isSelected,
  });

  static List<Plant> plantList = [
    Plant(
        plantId: 0,
        price: 22,
        category: 'Indoor',
        plantName: 'Sanseviera',
        size: 'Small',
        rating: 4.5,
        humidity: 34,
        temperature: '23 - 34',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/plant-flutter.appspot.com/o/plants%2F07d05863-5a2f-4bdf-8532-5a888c9c97c2?alt=media&token=12fd70c9-8815-4596-9500-20640518410c',
        isFavorated: true,
        description:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 1,
        price: 11,
        category: 'Outdoor',
        plantName: 'Philodendron',
        size: 'Medium',
        rating: 4.8,
        humidity: 56,
        temperature: '19 - 22',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/plant-flutter.appspot.com/o/plants%2F07d05863-5a2f-4bdf-8532-5a888c9c97c2?alt=media&token=12fd70c9-8815-4596-9500-20640518410c',
        isFavorated: false,
        description:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 2,
        price: 18,
        category: 'Indoor',
        plantName: 'Beach Daisy',
        size: 'Large',
        rating: 4.7,
        humidity: 34,
        temperature: '22 - 25',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/plant-flutter.appspot.com/o/plants%2F07d05863-5a2f-4bdf-8532-5a888c9c97c2?alt=media&token=12fd70c9-8815-4596-9500-20640518410c',
        isFavorated: false,
        description:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 3,
        price: 30,
        category: 'Outdoor',
        plantName: 'Big Bluestem',
        size: 'Small',
        rating: 4.5,
        humidity: 35,
        temperature: '23 - 28',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/plant-flutter.appspot.com/o/plants%2F07d05863-5a2f-4bdf-8532-5a888c9c97c2?alt=media&token=12fd70c9-8815-4596-9500-20640518410c',
        isFavorated: false,
        description:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 4,
        price: 24,
        category: 'Recommended',
        plantName: 'Big Bluestem',
        size: 'Large',
        rating: 4.1,
        humidity: 66,
        temperature: '12 - 16',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/plant-flutter.appspot.com/o/plants%2F07d05863-5a2f-4bdf-8532-5a888c9c97c2?alt=media&token=12fd70c9-8815-4596-9500-20640518410c',
        isFavorated: true,
        description:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
  ];

  static void updatePlantList(List<Plant> newList) {
    for (int i = 0; i < newList.length; i++) {
      newList[i].plantId = plantList.length ;
      plantList.add(newList[i]);
    }
  }

  static List<Plant> getFavoritedPlants() {
    List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  static List<Plant> addedToCartPlants() {
    List<Plant> _selectedPlants = Plant.plantList;
    return _selectedPlants
        .where((element) => element.isSelected == true)
        .toList();
  }
}

class Addplant extends StatelessWidget {
  const Addplant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('plants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>> querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                querySnapshot.docs;

            List<Plant> updatedPlantList = documents.map((doc) {
              Map<String, dynamic> data = doc.data();
              int id = Plant.plantList.length;
              return Plant(
                plantId: id,
                price: data['price'],
                category: data['category'] as String,
                plantName: data['name'] as String,
                size: data['size'] as String,
                rating: 4.5,
                humidity: 36,
                temperature: data['temperature'] as String,
                imageURL: data['url'] as String,
                isFavorated: false,
                description: data['description'] as String,
                isSelected: false,
              );
            }).toList();

            Plant.updatePlantList(updatedPlantList);

            log('${Plant.plantList.length.toString()} plants found');

            return ListView.builder(
                itemCount: Plant.plantList.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DetailPage(
                                    plantId: Plant.plantList[index].plantId),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: PlantWidget(
                          index: index, plantList: Plant.plantList));
                });
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
