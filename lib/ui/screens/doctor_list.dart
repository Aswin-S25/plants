// screens/doctor_list_screen.dart

import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';
import 'package:plant/ui/screens/widgets/doctor_card.dart';
import 'chat_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(name: 'Dr. John Samuel', specialization: 'General Plant Diseases'),
    Doctor(name: 'Dr. Jane Smith', specialization: 'Insect Infestation'),
  ];

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(doctor: doctors[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
