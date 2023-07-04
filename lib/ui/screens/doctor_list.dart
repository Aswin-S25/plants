// screens/doctor_list_screen.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';
import 'package:plant/ui/screens/widgets/doctor_card.dart';
import 'chat_screen.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> doctors = [];
  Map<String, dynamic>? doctorMap;

  @override
  void initState() {
    super.initState();
    listDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'DOCTORS',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(
            doctor: doctors[index],
            onTap: () {
              String roomID =
                  chatRoomId(doctors[index].name, doctors[index].name);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    doctor: doctors[index],
                    chatRoomId: roomID,
                    userMap: doctorMap,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  //LIST ALL DOCTORS
void listDoctors() async {
  await Firebase.initializeApp();
  log('listDoctors');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();

  setState(() {
    doctors = querySnapshot.docs.map((doc) {
      doctorMap = doc.data() as Map<String, dynamic>; // Assign the value to the global doctorMap variable
      log(doc.id); // Log the document ID
      return Doctor(
        id: doc.id, // Store the document ID in the id field of Doctor class
        name: doctorMap!['name'],
        specialization: doctorMap!['specialisation'],
      );
    }).toList();
  });

  log('doctors: $doctors');
}


//

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
}
