import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:toml/loader.dart';
import 'package:d20/d20.dart';

var total_dice = List.empty(growable: true);
var wrath_total = List.empty(growable: true);
var tot_success;

Future<void> diceCommand(CommandContext ctx, String content) async {
  final d20 = D20();
  var cfg = await loadConfig('config.toml');
  var cont = content.replaceAll('${cfg['Bot']['Prefix']}roll ', '').split(' ');
  var rolled;
  var wroll;

  if (int.parse(cont[0]) >= 51) {
    await ctx
        .sendMessage(MessageBuilder.content('Please roll less than 50 dice'));
  } else {
    for (var i = 1; i <= int.parse(cont[0]); i++) {
      rolled = d20.rollWithStatistics('1d6');
      total_dice.add(rolled.finalResult);
    }
    var explode = {};

    total_dice
        .forEach((e) => explode.update(e, (x) => x + 1, ifAbsent: () => 1));
    if (explode.containsKey(4) ||
        explode.containsKey(5) ||
        explode.containsKey(6)) {
      tot_success = explode[4] + explode[5] + explode[6];
    }

    if (int.parse(cont[1]) >= 0) {
      for (var i = 1; i <= int.parse(cont[1]); i++) {
        wroll = d20.rollWithStatistics('1d6');
        wrath_total.add(wroll.finalResult);
      }
    } else {
      wroll = d20.rollWithStatistics('1d6');
      wrath_total.add(wroll.finalResult);
    }

    await ctx.sendMessage(MessageBuilder.content(
        total_dice.toString() + ' Total Successes: ' + tot_success.toString() + ' Wrath: ' + wrath_total.toString()
    ));

    total_dice.clear();
    wrath_total.clear();
  }
}

