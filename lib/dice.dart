import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:toml/loader.dart';
import 'package:d20/d20.dart';

var total_dice = List.empty();

Future<void> diceCommand(CommandContext ctx, String content) async {
  final d20 = D20();
  var cfg = await loadConfig('config.toml');
  var cont = content.replaceAll('${cfg['Bot']['Prefix']}roll ', '');
  var rolled;
  print(int.parse(cont));
  for ( var i = 0; i <= int.parse(cont)-1; i++ ) {
    print(i);
    rolled = d20.rollWithStatistics('1d6');
    print(rolled.results[0].results);
    total_dice.insert(-1, rolled.results[0].results);
  }

  print('a'+total_dice[0].toString());

  await ctx.sendMessage(MessageBuilder.content(total_dice.toString()));
  /*await ctx.sendMessage(
      content: 'Rolled ${rolled.finalResult}, ${rolled.rollNotation}');
  await ctx.sendMessage(
      content:
          '${await dieFace(rolled.results[0].results[0])} ${await dieFace(rolled.results[0].results[1])} ${await dieFace(rolled.results[0].results[2])} ');*/
}

Future<String> dieFace(int face) async {
  var newFace;
  switch (face) {
    case 1:
      newFace = IGuildEmoji.fromId('838208311135830057').id; // https://cdn.discordapp.com/emojis/838208311135830057.png?v=1
      break;
    case 2:
      newFace = IGuildEmoji.fromId('838208311114858526').id; // https://cdn.discordapp.com/emojis/838208311114858526.png?v=1
      break;
    case 3:
      newFace = IGuildEmoji.fromId('838208311144873984').id; // https://cdn.discordapp.com/emojis/838208311144873984.png?v=1
      break;
    case 4:
      newFace = IGuildEmoji.fromId('838220704699908118').id; // https://cdn.discordapp.com/emojis/838220704699908118.png?v=1
      break;
    case 5:
      newFace = IGuildEmoji.fromId('838208311135830058').id; // https://cdn.discordapp.com/emojis/838208311135830058.png?v=1
      break;
    case 6:
      newFace = IGuildEmoji.fromId('838208310930702349').id; // https://cdn.discordapp.com/emojis/838208310930702349.png?v=1
      break;
  }

  print(newFace);
  return '<:dice$face:$newFace>';
}