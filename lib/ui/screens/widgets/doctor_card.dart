// widgets/doctor_card.dart

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
      title: Text(doctor.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Constants.primaryColor)),
      subtitle: Text(doctor.specialization,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
