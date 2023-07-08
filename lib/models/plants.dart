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
        stream: FirebaseFirestore.instance.collection('plants').snapshots() ,
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
