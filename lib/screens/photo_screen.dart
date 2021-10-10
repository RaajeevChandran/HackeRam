import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camcoder/constants.dart';
import 'package:camcoder/screens/edit_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_action_sheet/platform_action_sheet.dart';
import 'dart:async';
import 'dart:io';
import "package:http/http.dart" as http;

class PhotoScreen extends StatefulWidget {
  static const routeName = '/photo';
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File _image;
  String processMessage = "";
  bool processing = false;

  String _selectedLanguage = "Javascript";

  Future getImage(ImageSource source, BuildContext context) async {
    final result = await ImagePicker.platform.pickImage(source: source);
    Navigator.pop(context);
    if (result != null) {
      print("file picked");
      File file = File(result.path);

      setState(() {
        _image = file;
      });
    }
  }

  void openSheet() {
    PlatformActionSheet().displaySheet(context: context, actions: [
      ActionSheetAction(
        text: "Take Picture",
        onPressed: () => getImage(ImageSource.camera, context),
      ),
      ActionSheetAction(
        text: "Choose picture from gallery",
        onPressed: () => getImage(ImageSource.gallery, context),
      ),
    ]);
  }

  void openEditor() async {
    var formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(_image.path)});
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 400,
              child: FutureBuilder(
                future: Dio().post("https://camcoderapi.herokuapp.com/api/ocr",
                    data: formData),
                builder: (context, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/loading2.json'),
                          Text(
                              "Extracting text from image")
                        ],
                      );
                    case ConnectionState.done:
                      return FutureBuilder(
                        future: Dio().post(
                            'https://camcoderapi.herokuapp.com/api/detect',
                            data: {'code': snap.data.toString()}),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/loading2.json'),
                                  Text(
                                      "Detecting the source code")
                                ],
                              );
                            case ConnectionState.done:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  
                                  Text(
                                      "Tap YES if it's right!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 5),
                                  Text("Is your code written in"),
                                  SizedBox(height: 5),
                                  Text(
                                    snapshot.data.toString().toUpperCase() +
                                        " ?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  ),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    child: Text("YES"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                    language: snapshot.data
                                                        .toString()
                                                        .toLowerCase(),
                                                    ocrResult:
                                                        snap.data.toString(),
                                                        imageUrl: _image.path,
                                                  )));
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  Text("OR",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      "Choose from the list of languages below if it's wrong"),
                                  SizedBox(height: 5),
                                  DropdownButton<String>(
                                      value: _selectedLanguage,
                                      dropdownColor:
                                          Constants.barBackgroundColor,
                                      items: <String>[
                                        'Javascript',
                                        'C++',
                                        'C',
                                        'Java',
                                        'Python'
                                      ].map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  color:
                                                      Constants.accentColor)),
                                        );
                                      }).toList(),
                                      onChanged: (newSelection) {
                                        changeLanguage(newSelection);
                                      }),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                      child: Text("Done"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditScreen(
                                                      language:
                                                          _selectedLanguage
                                                              .toLowerCase(),
                                                      ocrResult:
                                                          snap.data.toString(),
                                                    )));
                                      })
                                ],
                              );
                            default:
                              return Text("Err");
                          }
                        },
                      );
                    default:
                      return Text("err");
                  }
                },
              ),
            ),
          );

          // setState(() {
          //   processing = false;
          // });
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => EditScreen(
          //               language: _selectedLanguage,
          //               ocrResult: result,
          //             )));
        });
  }

  Future<String> ocrResult() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://camcoderapi.herokuapp.com/api/ocr'));
    request.files.add(await http.MultipartFile.fromPath('file', _image.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return "";
    }
  }

  void changeLanguage(String newSelection) {
    if (mounted) {
      setState(() {
        _selectedLanguage = newSelection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 4),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: _image != null
                  ? Image.file(_image, fit: BoxFit.contain)
                  : null,
            ),
            Spacer(),
            Row(children: [
              ElevatedButton(
                onPressed: openSheet,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                child: Text("Select Code Image",
                    style:
                        TextStyle(fontSize: 12, color: Constants.accentColor)),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _image == null ? null : openEditor,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                child: processing
                    ? CircularProgressIndicator()
                    : Text("Run Code Image",
                        style: TextStyle(
                            fontSize: 12, color: Constants.accentColor)),
              ),
            ]),
            Spacer(),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
