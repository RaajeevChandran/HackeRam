import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:camcoder/models/snippet.dart';
import 'package:camcoder/models/snippets.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import 'snippet_screen.dart';

class SnippetsScreen extends StatefulWidget {
  @override
  _SnippetsScreenState createState() => _SnippetsScreenState();
}

class _SnippetsScreenState extends State<SnippetsScreen> {
  List snipsList;
  @override
  void initState() {
    // TODO: implement initState
    getSnipList();
    super.initState();
  }

  Future<List> getSnipList() async {
    var box = await Hive.openBox('snips');
    List snipp = await box.get('snipsName');

    return snipp;
  }

  Future<Snippet> getSnip(String snipName) async {
    var box = await Hive.openBox('snips');
    Snippet snipp = await box.get(snipName);

    return snipp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: FutureBuilder(
            future: getSnipList(),
            builder: (context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.data.length == 0) {
                    return Lottie.asset('assets/empty.json');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildSnippetRow(context, index, snapshot.data);
                    },
                  );
                default:
                  return Text('error');
              }
            }),
      ),
    ]);
  }

  Widget _buildSnippetRow(
      BuildContext context, int index, List<dynamic> snipsList) {
    return Container(
      color: Constants.backgroundColor,
      child: Row(
        children: [
          _buildSnippet(context, index, snipsList[index]),
          // _buildSnippet(context, index * 2 + 1),
        ],
      ),
    );
  }

  Widget _buildSnippet(BuildContext context, int index, String snipName) {
    return FutureBuilder(
        future: getSnip(snipName),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              return Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SnippetScreen(
                          language:snapshot.data.language,
                          name: snapshot.data.name,
                          imageUrl: snapshot.data.imageURL,
                          code: snapshot.data.code,
                        ),
                      ),
                    );
                  },
                  child: GFCard(
                    boxFit: BoxFit.cover,
                    image: Image.file(File(snapshot.data.imageURL)),
                    content: Column(
                      children: [
                        Text(snapshot.data.name),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return Text('Something seriously went');
          }
        });
  }
}
