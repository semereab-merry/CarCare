import 'package:carlife/model/news/newsResponse.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatelessWidget {
  final Article article;

  const NewsList({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: EdgeInsets.all(7),
      child: ListTile(
        onTap: () async {
          await canLaunchUrl(article.url as Uri)
              ? await launchUrl(article.url as Uri)
              : throw 'Could not launch ${article.url}';
        },
        title: Text(
          article.title!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          article.description!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        leading: article.urlToImage != null
            ? Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(article.urlToImage!),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
