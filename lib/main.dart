import 'package:flutter/material.dart';
import 'package:plant/ui/disease_detection.dart';

import 'ui/onboarding_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Screen',
      home: SymptomSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
