import 'package:flutter/material.dart';

class NewsQueryModel {
  late String newsHead;
  late String newsDes;
  late String newsImage;
  late String newsUrl;
  NewsQueryModel(
      {this.newsHead = "News Headlines",
      this.newsDes = "News Description",
      this.newsImage = "News Image loading",
      this.newsUrl = "News Url"});
  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsDes: news["description"].toString(),
      newsHead: news["title"].toString(),
      newsImage: news["urlToImage"].toString(),
      newsUrl: news["url"].toString(),
    );
  }
}
