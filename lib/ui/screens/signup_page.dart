import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/services/googleauth.dart';
import 'package:plant/ui/root_page.dart';
import 'package:plant/ui/screens/signin_page.dart';
import 'package:plant/ui/screens/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  // String? selectedRole;

  // final List<Map<String, dynamic>> _items = [
  //   {
  //     'value': 'User',
  //     'label': 'User',
  //   },
  //   {
  //     'value': 'doctor',
  //     'label': 'Doctor',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/signup.png'),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextfield(
                  obscureText: false,
                  hintText: 'Enter Email',
                  icon: Icons.email,
                  controller: emailController,
                ),
                CustomTextfield(
                  obscureText: false,
                  hintText: 'Enter Full name',
                  icon: Icons.person,
                  controller: nameController,
                ),
                CustomTextfield(
                  obscureText: true,
                  hintText: 'Enter Password',
                  icon: Icons.lock,
                  controller: passwordController,
                ),
                // DropdownButtonFormField(
                //   items: _items
                //       .map((item) => DropdownMenuItem(
                //             child: Text(item['label']),
                //             value: item['value'],
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     selectedRole = value.toString();
                //   },
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide.none,
                //     ),
                //     hintText: 'Select Role',
                //     prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    registerUser(
                      context,
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                    );
                  },
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    log('Google Sign In');
                    GoogleSignInProvider().signInWithGoogle().then((user) {
                      if (user != null) {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: SignUp(),
                                type: PageTransitionType.bottomToTop));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const RootPage(),
                                type: PageTransitionType.bottomToTop));
                      }
                    });
                  },
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Constants.primaryColor),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Image.asset('assets/images/google.png'),
                        ),
                        Text(
                          'Sign Up with Google',
                          style: TextStyle(
                            color: Constants.blackColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: SignIn(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Have an Account? ',
                          style: TextStyle(
                            color: Constants.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Constants.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //register user
  void registerUser(
      BuildContext context, String email, String password, String name) async {
    // Validity check
    if (_formKey.currentState!.validate()) {
      try {
        log(name.toString());
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user to Firestore
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
        await userCredential.user!.sendEmailVerification();
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('users');
        await userCollection.doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          // Add other user details as needed
        });
        log('User Added');

        // // Add user details to the respective collection based on the role
        // if (  selectedRole.toString() == 'doctor') {
        //   CollectionReference doctorCollection =
        //       FirebaseFirestore.instance.collection('doctors');
        //   await doctorCollection.doc(userCredential.user!.uid).set({
        //     'name': name,
        //     'email': email,
        //     // Add other doctor details as needed
        //   });
        //   // } else {
        //   //   CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
        //   //   await userCollection.doc(userCredential.user!.uid).set({
        //   //     'name': name,
        //   //     'email': email,
        //   //     // Add other user details as needed
        //   //   });
        // }

        // Navigate to the desired screen
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: SignIn(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The password provided is too weak.'),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred.'),
          ),
        );
      }
    }
  }
}
