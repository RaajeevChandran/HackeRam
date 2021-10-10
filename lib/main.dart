import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'main_screen.dart';
import 'models/snippet.dart';
import 'models/snippets.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      var path = await getApplicationDocumentsDirectory();
      Hive
      ..init(path.path)
      ..registerAdapter(SnippetAdapter());
  List snipsName = [];

  var box = await Hive.openBox('snips');
  box.put('snipsName',snipsName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Constants.backgroundColor,
        accentColor: Constants.accentColor,
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          headline1: TextStyle(fontFamily: 'Quicksand'),
          headline2: TextStyle(fontFamily: 'Quicksand'),
          headline4: TextStyle(fontFamily: 'Quicksand'),
          headline5: TextStyle(fontFamily: 'NotoSans'),
          headline6: TextStyle(fontFamily: 'NotoSans'),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
          subtitle2: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: MainScreen(),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  String res = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: TextButton(
          onPressed: () async {
            // ignore: invalid_use_of_visible_for_testing_member
            final result = await ImagePicker.platform
                .pickImage(source: ImageSource.gallery);

            if (result != null) {
              print("file picked");
              File file = File(result.path);

              var request = http.MultipartRequest('POST',
                  Uri.parse('https://camcoderapi.herokuapp.com/api/decode'));
              request.files
                  .add(await http.MultipartFile.fromPath('file', file.path));
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: FutureBuilder<http.StreamedResponse>(
                          future: request.send(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              case ConnectionState.done:
                                return FutureBuilder(
                                  future: snapshot.data.stream.bytesToString(),
                                  builder: (context, snap) {
                                    switch (snap.connectionState) {
                                      case ConnectionState.waiting:
                                        return CircularProgressIndicator();
                                      case ConnectionState.done:
                                        return Text(snap.data.toString());
                                      default:
                                        return Text(("Error in result"));
                                    }
                                  },
                                );

                              default:
                                return Text("error");
                            }
                          },
                        ),
                      ));
            }
          },
          child: Text("Do"),
        ),
      ),
    ));
  }
}
