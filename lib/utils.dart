import 'dart:io' show Platform;
// import 'dart:convert';


String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

