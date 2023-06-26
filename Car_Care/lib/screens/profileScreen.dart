import 'package:carlife/utilis/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carlife/screens/loginScreen.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/utilis.dart';
import 'package:carlife/widgets/bigButtons.dart';
import 'addPostScreen.dart';
import 'package:carlife/utilis/globalVariable.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context as String,
        e.toString() as BuildContext,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 5,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 75,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                ),
                                child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    'Username:  ' + userData['username'],
                                    style: subHeading),
                              ),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return (snapshot.data as dynamic).docs.length == 0
                        ? SizedBox(
                            height: 30,
                            child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      child: Text(
                                        "No posts",
                                        style: emp_grey,
                                      ),
                                    ),
                                  )
                                ]))
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              );
                            },
                          );
                  }),
              const Divider(),
              const SizedBox(height: 14),
              _addPost(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                BigButtun(
                  text: 'Sign Out',
                  backgroundColor: mobileBackgroundColor,
                  textColor: primaryColor,
                  borderColor: Colors.grey,
                  function: () async {
                    // await AuthMethods().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                )
              ]),
            ]),
          );
  }

  _addPost() {
    return BigButtun(
        text: 'Add Post',
        backgroundColor: logoSelection,
        textColor: Colors.black,
        borderColor: Colors.black,
        function: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        });
  }
}
