// screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';

class ChatScreen extends StatelessWidget {
  final Doctor doctor;

  ChatScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat with ${doctor.name}',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text('Chatting functionality will be implemented later.'),
      ),
    );
  }
}
