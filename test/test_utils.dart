import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeTestEnvVariables() async {
  dotenv.testLoad(fileInput: File('test.env').readAsStringSync());
}
