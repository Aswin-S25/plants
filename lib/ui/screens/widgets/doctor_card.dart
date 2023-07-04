// // widgets/doctor_card.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:plant/constants.dart';
// import 'package:plant/models/doctors.dart';

// class DoctorCard extends StatelessWidget {
//   final Doctor doctor;
//   final VoidCallback onTap;

//   DoctorCard({required this.doctor, required this.onTap});



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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  DoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/doctor1.jpg'), // Replace with your desired doctor's image
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
        doctor.specialization,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.message),
        onPressed: onTap,
      ),
    );
  }
}

