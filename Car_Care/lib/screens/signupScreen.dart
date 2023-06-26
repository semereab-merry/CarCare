import 'dart:typed_data';

import 'package:carlife/resources/authMethods.dart';
import 'package:carlife/screens/home.dart';
import 'package:carlife/screens/loginScreen.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:carlife/widgets/textFieldImport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/webScreenLayout.dart';
import '../utilis/fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (res != "sccess") {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// fix the position
                  Flexible(flex: 1, child: Container()),

                  ///logo
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 100,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Car Care ",
                        style: logo,
                      ),
                    ],
                  ),

                  //separator
                  const SizedBox(
                    height: 15,
                  ),

// profile pic
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 44, backgroundImage: MemoryImage(_image!))
                          : const CircleAvatar(
                              radius: 44,
                              backgroundImage: NetworkImage(
                                  'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg')),
                      Positioned(
                        bottom: 0,
                        left: 50,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //separator
                  const SizedBox(
                    height: 8,
                  ),

                  /// text field imput for email
                  Container(
                    height: 52,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(left: 14),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                  ),

                  //separator
                  const SizedBox(
                    height: 8,
                  ),

                  /// text field input for password
                  Container(
                    height: 52,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(left: 14),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextFieldInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                  ),

                  //separator
                  const SizedBox(
                    height: 8,
                  ),

                  /// text field imput for username
                  Container(
                    height: 52,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(left: 14),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextFieldInput(
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                    ),
                  ),
                  //separator
                  const SizedBox(
                    height: 8,
                  ),

                  /// login button
                  InkWell(
                      onTap: signUpUser,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: login,
                              ),
                      )),

                  Flexible(flex: 2, child: Container()),

                  ///transistion to signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an account?  "),
                      ),
                      GestureDetector(
                          onTap: navigateToLogin,
                          child: const Text(
                            "Log in",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ))),
    );
  }
}
