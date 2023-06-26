import 'package:carlife/model/news/newsResponse.dart';
import 'package:carlife/resources/newsApiServices.dart';
import 'package:carlife/utilis/colors.dart';
import 'package:carlife/utilis/fonts.dart';
import 'package:carlife/widgets/newsList.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 5,
        centerTitle: false,
        title: Text(
          "What is new",
          style: heading,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "The most intresting article and news today",
                style: emp_grey,
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Article>?>(
                  future: NewsApiServices().fetchNewsArticle(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article> newsArticle = snapshot.data!;
                      return ListView.builder(
                        itemCount: newsArticle.length,
                        itemBuilder: (context, index) {
                          return NewsList(article: newsArticle[index]);
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
