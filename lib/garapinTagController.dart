import 'dart:async';

import 'package:customtag/modal/garapinTagModel.dart';

class GarapinTagController {
  final StreamController<List<GarapinTagModel>> tagController =
      StreamController();
  Stream<List<GarapinTagModel>> get tagStream => tagController.stream;

  void dispose() {
    tagController.close();
  }
}
