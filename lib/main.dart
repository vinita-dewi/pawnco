import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pawnco/main_mobile.dart';

import 'main_web.dart';

Future<void> main() async {
  if (kIsWeb) {
    runApp(MainWeb());
  } else {
    runApp(MainMobile());
  }
}
