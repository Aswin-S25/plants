import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';
import 'package:plant/models/users.dart';
import 'package:plant/ui/screens/doctor_chatting.dart';
import 'package:plant/ui/screens/signin_page.dart';
import 'package:plant/ui/screens/widgets/doctor_card.dart';
import 'package:plant/ui/screens/widgets/user_card.dart';
import 'chat_screen.dart';

class DoctorHome extends StatefulWidget {
  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  List<Users> users = [];
  List<Users> filteredDoctors = [];
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'USERS',
              style: TextStyle(
                color: Colors.blueGrey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Logout',
                  style: TextStyle(
                      color: Color.fromARGB(255, 160, 61, 52), fontSize: 15),
                ),
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 160, 61, 52),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: TextField(
          //     controller: searchController,
          //     decoration: InputDecoration(
          //       labelText: 'Search Doctors',
          //       prefixIcon: Icon(Icons.search, color: Constants.primaryColor),
          //       border: OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: Constants.primaryColor,
          //         ),
          //         borderRadius: BorderRadius.circular(
          //             10.0), // Set the border radius when not focused
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(
          //           color: Color.fromARGB(255, 18, 19, 18),
          //         ),
          //         borderRadius: BorderRadius.circular(
          //             10.0), // Set the border radius when focused
          //       ),
          //       floatingLabelBehavior: FloatingLabelBehavior.never,
          //     ),
          //     onChanged: (value) {
          //       filterDoctors(value);
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black54.withOpacity(.6),
                ),
                Expanded(
                  child: TextField(
                    showCursor: false,
                    decoration: const InputDecoration(
                      hintText: 'Search Users',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      filterDoctors(value);
                    },
                  ),
                ),
                Icon(
                  Icons.mic,
                  color: Colors.black54.withOpacity(.6),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return UserCard(
                  doctor: filteredDoctors[index],
                  onTap: () {
                    String roomID = chatRoomId(
                      filteredDoctors[index].name,
                      filteredDoctors[index].name,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorChat(
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
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();

    setState(() {
      users = querySnapshot.docs.map((doc) {
        doctorMap = doc.data() as Map<String, dynamic>;
        log(doc.id);
        return Users(
          id: doc.id,
          name: doctorMap!['name'],
          email: doctorMap!['email'],
        );
      }).toList();
      filteredDoctors = users;
    });

    log('doctors: $users');
  }

  void filterDoctors(String query) {
    setState(() {
      filteredDoctors = users.where((doctor) {
        final doctorName = doctor.name.toLowerCase();
        final doctorSpecialization = doctor.email.toLowerCase();
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
