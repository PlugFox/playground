import 'package:flutter/foundation.dart';

const String kFlavor = String.fromEnvironment('FLAVOR', defaultValue: kDebugMode ? 'develop' : 'production');

const String kEnvironment = String.fromEnvironment('ENVIRONMENT', defaultValue: kDebugMode ? 'develop' : 'production');

const String kTitle = String.fromEnvironment('TITLE', defaultValue: 'Playground');
