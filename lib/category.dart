import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:news_app/model.dart';
import 'package:news_app/webview.dart';

class category extends StatefulWidget {
  String cat;
  category({required this.cat});

  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  List<NewsQueryModel> catlist = <NewsQueryModel>[];
  bool isloading = true;
  getnewsbycategory(String cat) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$cat&apiKey=bf0b7673f4634da19c160d0c3a3a7a8f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsquery = NewsQueryModel();
          newsquery = NewsQueryModel.fromMap(element);
          catlist.add(newsquery);
          setState(() {
            isloading = false;
          });
          if (i == 20) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getnewsbycategory(widget.cat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Global News"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.cat,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            child: isloading
                ? Container(
                    height: 500,
                    child: Center(child: CircularProgressIndicator()))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: catlist.length,
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
                                              catlist[index].newsUrl,
                                            )));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        catlist[index].newsImage,
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
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black,
                                                ]),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  catlist[index].newsHead,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  catlist[index]
                                                              .newsDes
                                                              .length >
                                                          35
                                                      ? "${catlist[index].newsDes.substring(0, 25)}...."
                                                      : catlist[index].newsDes,
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
        ],
      ))),
    );
  }
}
