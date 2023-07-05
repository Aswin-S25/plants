// // widgets/doctor_card.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:plant/constants.dart';
// import 'package:plant/models/doctors.dart';

// class UserCard extends StatelessWidget {
//   final Doctor doctor;
//   final VoidCallback onTap;

//   UserCard({required this.doctor, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(doctor.name,
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: Constants.primaryColor)),
//       subtitle: Text(doctor.specialization,
//           style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//       onTap: onTap,
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';
import 'package:plant/models/users.dart';

class UserCard extends StatelessWidget {
  final Users doctor;
  final VoidCallback onTap;

  UserCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    log(doctor.name, name: 'UserCard');
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
      child: Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/doctor1.jpg'), // Replace with your desired doctor's image
            radius: 30,
          ),
          title: Text(
            doctor.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Constants.primaryColor,
            ),
          ),
          subtitle: Text(
            doctor.email,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.message),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}
