import 'package:carlife/model/news/newsResponse.dart';
import 'package:carlife/resources/newsApiServices.dart';
import 'package:carlife/screens/addCars.dart';
import 'package:carlife/screens/carProfileScreen.dart';
import 'package:carlife/screens/feedScreen.dart';
import 'package:carlife/screens/newsScreen.dart';
import 'package:carlife/widgets/newsList.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../utilis/colors.dart';
import '../utilis/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewsApiServices client = NewsApiServices();

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var uid = userProvider.getUser.uid;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "What's new",
                  style: subHeading,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NewsScreen()),
                    );
                  },
                  child: Text(
                    "See all",
                    style: link,
                  ),
                )
              ],
            ),
            FutureBuilder<List<Article>?>(
                future: NewsApiServices().fetchNewsArticle(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                          height: 170,
                          child: Row(
                            children: [
                              const CircularProgressIndicator(),
                            ],
                          )),
                    );
                  }
                  List<Article>? newsArticle = snapshot.data;
                  return SizedBox(
                    height: 130,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return NewsList(article: newsArticle![index]);
                            },
                            childCount: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
        Column(
          children: [
            const Divider(),
            // all the column is for cars section
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Text(
                      "Your cars",
                      style: subHeading,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AddCarsScreen()),
                        );
                      },
                      child: Text(
                        "+ Add cars",
                        style: link,
                      ),
                    )
                  ],
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('cars')
                      .where('uid', isEqualTo: uid)
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
                                        "No cars added",
                                        style: emp_grey,
                                      ),
                                    ),
                                  )
                                ]))
                        : Column(children: [
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0.5,
                                mainAxisSpacing: 0.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                var carid = snap['carId'].toString();

                                return SizedBox(
                                  height: 100,
                                  child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CarProfileScreen(
                                                          carid: carid,
                                                        )),
                                              );
                                            },
                                            child: Container(
                                                width: 110,
                                                padding:
                                                    const EdgeInsets.all(25),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: primaryColor,
                                                ),
                                                child: Column(children: [
                                                  Text(
                                                    snap['title'].toString(),
                                                    style: emp_button,
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons
                                                        .directions_car_rounded,
                                                    color: secondaryColor,
                                                  )
                                                ])),
                                          ),
                                        ),
                                      ]),
                                );
                              },
                            ),
                          ]);
                  },
                ),
              ],
            ),
            const Divider(),

            // all the following column is for cars section
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Text(
                      "New posts",
                      style: subHeading,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const FeedScreen()),
                        );
                      },
                      child: Text(
                        "See all",
                        style: link,
                      ),
                    )
                  ],
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return (snapshot.data as dynamic).docs.length == 0
                        ? SizedBox(
                            height: 45,
                            child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      child: Text(
                                        "No posts available added",
                                        style: emp_grey,
                                      ),
                                    ),
                                  )
                                ]))
                        : Column(children: [
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0.5,
                                mainAxisSpacing: 0.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];

                                return SizedBox(
                                  child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Container(
                                            width: 150,
                                            padding: const EdgeInsets.all(5),
                                            child: Column(children: [
                                              Image.network(
                                                snap['postUrl'].toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ])),
                                      ]),
                                );
                              },
                            ),
                          ]);
                  },
                ),
              ],
            ),
          ],
        ),
      ]),

      // )
    );
  }
}
