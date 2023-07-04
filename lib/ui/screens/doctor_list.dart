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
  List<Doctor> filteredDoctors = [];
  Map<String, dynamic>? doctorMap;
  TextEditingController searchController = TextEditingController();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                prefixIcon: Icon(Icons.search, color: Constants.primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(
                      10.0), // Set the border radius when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 18, 19, 18),
                  ),
                  borderRadius: BorderRadius.circular(
                      10.0), // Set the border radius when focused
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              onChanged: (value) {
                filterDoctors(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(
                  doctor: filteredDoctors[index],
                  onTap: () {
                    String roomID = chatRoomId(
                      filteredDoctors[index].name,
                      filteredDoctors[index].name,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          doctor: filteredDoctors[index],
                          chatRoomId: roomID,
                          userMap: doctorMap,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // LIST ALL DOCTORS
  void listDoctors() async {
    await Firebase.initializeApp();
    log('listDoctors');
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();

    setState(() {
      doctors = querySnapshot.docs.map((doc) {
        doctorMap = doc.data() as Map<String, dynamic>;
        log(doc.id);
        return Doctor(
          id: doc.id,
          name: doctorMap!['name'],
          specialization: doctorMap!['specialisation'],
        );
      }).toList();
      filteredDoctors = doctors;
    });

    log('doctors: $doctors');
  }

  void filterDoctors(String query) {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final doctorName = doctor.name.toLowerCase();
        final doctorSpecialization = doctor.specialization.toLowerCase();
        final searchQuery = query.toLowerCase();

        return doctorName.contains(searchQuery) ||
            doctorSpecialization.contains(searchQuery);
      }).toList();
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
}
