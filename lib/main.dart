import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customtag/garapinTag.dart';
import 'package:customtag/garapinTagController.dart';
import 'package:customtag/modal/garapinTagModel.dart';
import 'package:customtag/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(GarapinTag());
}

class GarapinTag extends StatefulWidget {
  const GarapinTag({Key key, this.controller}) : super(key: key);
  final GarapinTagController controller;

  @override
  _GarapinTagState createState() => _GarapinTagState();
}

class _GarapinTagState extends State<GarapinTag> {
  void initState() {
    String host = Platform.isAndroid ? '10.0.2.2:8081' : 'localhost:8080';

    Firestore.instance.settings(
      sslEnabled: false,
      host: host,
      persistenceEnabled: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Test App",
        //home: MyHomePage(),
        home: Provider<Database>(
          create: (_) => FirestoreDatabase(),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  String _uid = "rQrkBPCdmSKrjrxX59GS";

  Future<void> _createTags(
      String uid, String tagName, Database database) async {
    await database.writeTag(uid, GarapinTagModel(title: tagName).toMap());
  }

  Future<void> _insertImage(
      String uid, String tagID, String filename, Database database) async {
    List<dynamic> imagefile = List<dynamic>();
    imagefile.add(filename);

    await database.insertImage(
        uid,
        tagID,
        GarapinTagModel(
          tagImage: imagefile,
        ).toMap());
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Container(
        color: Colors.white,
        child: Center(
            child: GarapInTag(
          labeltext: "Masukan bagian yang bisa di Custom",
          width: MediaQuery.of(context).size.width * 0.8,
          tagStream: database.readGarapinTags(_uid),
          //imageStream: database.readImageTags(_uid),
          database: database,
          onSubmitted: (value) {
            _createTags(_uid, value, database);
          },
          onImagePicked: (pickedFile, tagid) {
            _insertImage(_uid, tagid, pickedFile.path, database);
          },
          onDeleteImage: (value, tagID) {
            database.deleteImage(_uid, tagID, {
              "tagImage": FieldValue.arrayRemove([value])
            });
          },
          onClose: (value) {
            database.deleteTag(_uid, value);
            print(value);
          },
        )));
  }
}
