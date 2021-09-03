import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'dart:io';

Future<void> shutdownCommand(CommandContext ctx, String content) async {
  await ctx.message.delete();
  await ctx.sendMessage(MessageBuilder.content('Okay Boss... Shutting down.'));
  Process.killPid(pid);
}
