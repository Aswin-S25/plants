import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/ui/screens/doctor_list.dart';
import 'package:plant/ui/screens/notification_screen.dart';
import 'package:plant/ui/screens/signin_page.dart';
import 'package:plant/ui/screens/widgets/plant_widget.dart';
import 'package:plant/ui/screens/widgets/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const url = "https://i.imgur.com/BoN9kdC.png";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        // height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Constants.primaryColor.withOpacity(.5),
                  width: 5.0,
                ),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(url),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .3,
              child: Row(
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                      height: 24,
                      child: Image.asset("assets/images/verified.png")),
                ],
              ),
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: TextStyle(
                color: Constants.blackColor.withOpacity(.3),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              // height: size.height * .7,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const ProfileWidget(
                  //   icon: Icons.person,
                  //   title: 'My Profile',
                  // ),
                  ProfileWidget(
                    icon: Icons.medical_information_outlined,
                    title: 'Find Doctor',
                    route: DoctorListScreen(),
                  ),
                  ProfileWidget(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    route: NotificationPage(),
                  ),
                  // const ProfileWidget(
                  //   icon: Icons.settings,
                  //   title: 'Settings',
                  // ),
                  // const ProfileWidget(
                  //   icon: Icons.chat,
                  //   title: 'FAQs',
                  // ),
                  // const ProfileWidget(
                  //   icon: Icons.share,
                  //   title: 'Share',
                  // ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Constants.blackColor.withOpacity(.5),
                              size: 24,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                color: Constants.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Constants.blackColor.withOpacity(.4),
                          ),
                          color: Constants.blackColor.withOpacity(.4),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
