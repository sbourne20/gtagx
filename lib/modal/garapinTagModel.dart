import 'package:cloud_firestore/cloud_firestore.dart';

class GarapinTagModel {
  String title;
  String iddoc;
  List<dynamic> tagImage;
  GarapinTagModel({this.title, this.iddoc, this.tagImage});

  factory GarapinTagModel.fromMap(
      Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    final String title = data['title'];
    final List<dynamic> tagImage = data['tagImage'];

    return GarapinTagModel(
      iddoc: documentID,
      title: title,
      tagImage: tagImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (iddoc != null) 'DocumentID': iddoc,
      if (tagImage != null) 'tagImage': FieldValue.arrayUnion(tagImage),
    };
  }
}
