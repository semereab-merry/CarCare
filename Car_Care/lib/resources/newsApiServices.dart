import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:carlife/model/news/newsResponse.dart';

class NewsApiServices {
  String api = "e179807180984b2da658ccc9463f9e50";
  String _url =
      "https://newsapi.org/v2/everything?q='Toyota'+'Nissan'+'Hyundai'&sortBy=popularity&language=en";
  late Dio _dio;
  String getTopHeadlinesUrl =
      "https://newsapi.org/v2/top-headlines?q='Toyota'+'Nissan'+'Hyundai'&sortBy=popularity&language=en";

  NewsApiServices() {
    _dio = Dio();
    _dio.options.headers['Authorization'] =
        'Bearer e179807180984b2da658ccc9463f9e50';
  }

  Future<List<Article>?> fetchNewsArticle() async {
    try {
      Response response = await _dio.get(_url);
      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles;
    } catch (e) {
      throw Exception(e);
    }
  }

  
}
