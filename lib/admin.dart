import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'dart:io';

import 'package:toml/loader.dart';

Future<void> shutdownCommand(CommandContext ctx, String content) async {
  await ctx.message.delete();
  await ctx.sendMessage(MessageBuilder.content('Okay Boss... Shutting down.'));
  Process.killPid(pid);
}

Future<void> prefixCommand(CommandContext ctx, String content) async {
  // var cfg = await loadConfig('config.toml');
  // var db = await Db.create('mongodb+srv://${cfg['DB']['User']}:${cfg['DB']['Pass']}@gemini.hjehy.mongodb.net/gemini?retryWrites=true&w=majority');
  // await db.open();

  // var coll = db.collection('machine_spirit');
  print(ctx.guild.id);
}
