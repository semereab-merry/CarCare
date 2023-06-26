// ignore_for_file: use_build_context_synchronously

import 'package:carlife/resources/authMethods.dart';
import 'package:carlife/responsive/mobileScreenLayout.dart';
import 'package:carlife/responsive/responsive_layout.dart';
import 'package:carlife/responsive/webScreenLayout.dart';
import 'package:carlife/screens/signupScreen.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:carlife/widgets/textFieldImport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utilis/fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == "success") {
      //
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout())));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
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
                  Flexible(flex: 2, child: Container()),

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
                    height: 64,
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
                    height: 24,
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
                    height: 28,
                  ),

                  /// login button
                  GestureDetector(
                      onTap: loginUser,
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
                                'Log in',
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
                        child: const Text("Don't have an account?  "),
                      ),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
