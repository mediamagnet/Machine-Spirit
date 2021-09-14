import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<void> speciesCommand (CommandContext ctx, String Content) async {
  get('https://www.doctors-of-doom.com/api/species/');
}