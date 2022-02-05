/*
import 'package:deep_pick/deep_pick.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:nyxx_commander/nyxx_commander.dart';
import 'package:toml/toml.dart';
// import 'dart:html';
import 'dart:convert';

Future<void> speciesCommand (ICommandContext ctx, String Content) async {
  var cfg = TomlDocument.parse('config.toml');
  var client = Client();
  var keyword = Content.replaceAll(cfg['Bot']['Prefix']+'test ', '');
  var response = await client.get(Uri.parse('https://www.doctors-of-doom.com/api/species/'));
  var decoded = json.decode(response.body);
  var species = pick(decoded, keyword);
  print(species);
}*/
