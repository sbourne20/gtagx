import 'dart:math';
import 'package:customtag/modal/garapinTagModel.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<GarapinTagModel>> readGarapinTags(String uid);
  Future<void> writeTag(String uid, Map<String, dynamic> data);
  Future<void> deleteTag(String uid, String fcid);
  Future<void> insertImage(String uid, String fcID, Map<String, dynamic> data);
  Future<void> deleteImage(String uid, String fcID, Map<String, dynamic> data);
}

class FirestoreDatabase implements Database {
  final _service = FirestoreService.instance;

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Stream<List<GarapinTagModel>> readGarapinTags(String uid) =>
      _service.collectionStream(
        path: APIPath.userCustoms(uid),
        builder: (data, documentId) =>
            GarapinTagModel.fromMap(data, documentId),
      );

  Future<void> writeTag(String uid, Map<String, dynamic> data) =>
      _service.setData(
          path: APIPath.userCustom(
              uid, DateTime.now().toString().replaceAll(RegExp(' '), '+')),
          //uid,
          //generateRandomString(15)),
          data: data);

  Future<void> insertImage(
          String uid, String fcID, Map<String, dynamic> data) =>
      _service.updateData(
          //path: APIPath.userCustom(uid, fcID, generateRandomString(15)),
          path: APIPath.userCustom(uid, fcID),
          data: data);

  Future<void> deleteImage(
          String uid, String fcID, Map<String, dynamic> data) =>
      _service.updateData(
          //path: APIPath.userCustom(uid, fcID, generateRandomString(15)),
          path: APIPath.userCustom(uid, fcID),
          data: data);

  Future<void> deleteTag(String uid, String fcid) =>
      _service.deleteData(path: APIPath.userCustom(uid, fcid));
}
