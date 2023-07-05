import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant/ui/onboarding_screen.dart';
import 'package:plant/ui/root_page.dart';
import 'package:plant/ui/screens/chat_screen.dart';
import 'package:plant/ui/screens/doctor_home.dart';
import 'package:plant/ui/screens/doctor_list.dart';
import 'package:plant/ui/screens/home_page.dart';
import 'package:plant/ui/screens/signin_page.dart';
import 'package:plant/ui/screens/signup_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Screen',
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the authentication state
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              log(snapshot.data.toString());
              // User is signed in
              log('User is signed in!');
              log(snapshot.data!.email.toString());
              if (snapshot.data!.email == 'paul@gmail.com' ||
                  snapshot.data!.email == "john@gmail.com" ||
                  snapshot.data!.email == "appukuttan@gmail.com") {
                return DoctorHome();
              }
              return RootPage();
            } else {
              // User is signed out
              log('User is currently signed out!');
              return SignIn();
            }
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
