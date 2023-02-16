import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/model/article_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int index = 0;
  List<Article> articleList = [];
  @override
  void initState() {
    super.initState();
    fetchdata();
    // setState(() {
    //   fetchdata();
    // });
  }

  @override
  Widget build(BuildContext context) {
    TabController con = TabController(length: articleList.length, vsync: this);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "News App",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          backgroundColor: Colors.blue[50],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List<Article>>(
              future: fetchdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  con =
                      TabController(length: snapshot.data!.length, vsync: this);
                  print("Data Recieved");
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: TabBar(
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.blue,
                            controller: con,
                            tabs: [
                              for (int i = 0; i < snapshot.data!.length; i++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data![i].source.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: con,
                            children: [
                              for (int i = 0; i < snapshot.data!.length; i++)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.network(
                                          snapshot.data![i].urlToImage),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 05, 15.0, 05.0),
                                      child: Text(
                                        snapshot.data![i].title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 05, 15.0, 20.0),
                                      child: Text(
                                        snapshot.data![i].description,
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Url:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 15.0, 05.0),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        webContainer(urls:snapshot.data![i].url),));

                                            // await launchUrl(
                                            //   Uri.parse(snapshot.data![i].url),
                                            //   mode: LaunchMode.inAppWebView,
                                            // );
                                          },
                                          child: Text(snapshot.data![i].url)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text('No Data'),
                );
              }),
        ));
  }

  Future<List<Article>> fetchdata() async {
    if (articleList.isNotEmpty) return articleList;
    final startData = Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2023-01-17&sortBy=publishedAt&apiKey=9258475f7711467991e1381d12788255');
    final response = await http.get(startData);

    if (response.statusCode == 200) {
      articleList = [];
      var data = json.decode(response.body)['articles'];
      for (var articleItem in data) {
        articleList.add(Article.fromJson(articleItem));
      }

      return articleList;
    } else {
      print("error in data fetching");
      return [];
    }
  }
}
