import 'package:carlife/screens/profileScreen.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carlife/utilis/globalVariable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 5,
        centerTitle: false,
        actions: [
          GestureDetector(
              onTap: () => navigationTapped(1),
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      height: 70,
                    ),
                  ],
                ),
              )),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              );
            },
            // onPressed: () => navigationTapped(2),
            icon: const Icon(
              Icons.person,
              color: secondaryColor,
            ),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}
