import 'dart:io' show Platform;
// import 'dart:convert';
import 'package:toml/loader/fs.dart';

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

Future<String> helpCommandGen(String commandName, String description,
    {required String additionalInfo}) async {
  var cfg = await loadConfig('config.toml');
  final buffer = StringBuffer();

  buffer.write("${cfg['Bot']['Prefix']}commandName**");

  if (additionalInfo != null) {
    buffer.write(' `$additionalInfo`');
  }

  buffer.write(' - $description.\n');

  return buffer.toString();
}
