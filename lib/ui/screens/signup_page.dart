import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/ui/screens/signin_page.dart';
import 'package:plant/ui/screens/widgets/custom_textfield.dart';
import 'package:plant/ui/screens/widgets/plant_widget.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

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
                  icon: Icons.alternate_email,
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
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    registerUser(context, emailController.text, passwordController.text, nameController.text);
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
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Constants.primaryColor),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const SignIn(),
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
    

    // validity check
    if (_formKey.currentState!.validate()) {
      //register user
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        //save user to firestore
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
        await userCredential.user!.sendEmailVerification();
        //navigate to home
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const SignIn(),
                type: PageTransitionType.bottomToTop));
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
            content: Text('An error occured'),
          ),
        );
      }
    }
  }
}
