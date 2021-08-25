import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:news_app/model.dart';
import 'package:news_app/webview.dart';

import 'category.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController SearchController = TextEditingController();
  List<NewsQueryModel> newslist = <NewsQueryModel>[];
  List<NewsQueryModel> techlist = <NewsQueryModel>[];
  bool isloading = true;

  getnewsbyQuery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2021-08-23&sortBy=publishedAt&apiKey=bf0b7673f4634da19c160d0c3a3a7a8f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsquery = NewsQueryModel();
          newsquery = NewsQueryModel.fromMap(element);
          newslist.add(newsquery);
          setState(() {
            isloading = false;
          });

          if (i == 17) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  getnewsbytech() async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=bf0b7673f4634da19c160d0c3a3a7a8f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newstech = NewsQueryModel();
          newstech = NewsQueryModel.fromMap(element);
          techlist.add(newstech);
          setState(() {
            isloading = false;
          });
          if (i == 7) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  List<String> items = [
    "Sports",
    "Business",
    "Politics",
    "Health",
    "Government",
  ];
  @override
  void initState() {
    super.initState();
    getnewsbyQuery("BBC");
    getnewsbytech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Global News"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if ((SearchController.text).replaceAll(" ", "") ==
                                "") {
                              print("User Don,t search properly");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => category(
                                          cat: SearchController.text)));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              print(value);
                              if ((value).replaceAll(" ", "") == "") {
                                print("Blank Search");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            category(cat: value)));
                              }
                            },
                            controller: SearchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search News"),
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => category(
                                        cat: items[index],
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                            child: Text(
                              items[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
//Slider Carousel
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: isloading
                    ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()))
                    : CarouselSlider(
                        options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: true),
                        items: techlist.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              try {
                                return Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  webview(i.newsUrl)));
                                    },
                                    child: Container(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                child: i.newsImage.isNotEmpty
                                                    ? Image.network(
                                                        i.newsImage,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      )
                                                    : Image.asset(
                                                        "assets/news"),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                left: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.black12
                                                              .withOpacity(0),
                                                          Colors.black,
                                                        ]),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 14,
                                                        vertical: 8),
                                                    child: Text(
                                                      i.newsHead.length > 40
                                                          ? "${i.newsHead.substring(0, 35)}...."
                                                          : i.newsHead,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                                return Container();
                              }
                            },
                          );
                        }).toList(),
                      ),
              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        "LATEST NEWS",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
//LatestNews
              Container(
                width: double.infinity,
                child: isloading
                    ? Container(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newslist.length,
                        itemBuilder: (context, index) {
                          try {
                            return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => webview(
                                                newslist[index].newsUrl)));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            newslist[index].newsImage,
                                            fit: BoxFit.cover,
                                            scale: 1.0,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black,
                                                    ]),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newslist[index].newsHead,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      newslist[index]
                                                                  .newsDes
                                                                  .length >
                                                              35
                                                          ? "${newslist[index].newsDes.substring(0, 25)}...."
                                                          : newslist[index]
                                                              .newsDes,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ));
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        }),
              ),
              isloading
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => category(
                                              cat: "Technology",
                                            )));
                              },
                              child: Text("Show More")),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  final List carousellist = [Colors.yellow, Colors.blue, Colors.purple];
}
