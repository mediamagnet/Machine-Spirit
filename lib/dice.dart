import 'dart:math';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:toml/loader.dart';
import 'package:d20/d20.dart';



Future<void> diceCommand(CommandContext ctx, String content) async {
  var total_dice = List.empty(growable: true);
  var wrath_total = List.empty(growable: true);
  var tot_success;
  final d20 = D20();
  var cfg = await loadConfig('config.toml');
  var cont = content.replaceAll('${cfg['Bot']['Prefix']}roll ', '').split(' ');
  var rolled;
  var wroll;
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));

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
        .forEach((e) =>
        explode.update(e.toString(), (x) => x + 1, ifAbsent: () => 1));
    if (explode.containsKey('4') ||
        explode.containsKey('5') ||
        explode.containsKey('6')) {
      print(explode);

      var sixes = (explode['6'] ?? 0) * 2;
      tot_success = (explode['4'] ?? 0) + (explode['5'] ?? 0) + sixes;
    }

    tot_success ??= 0;

    if (cont.length == 1 || cont[1] == '0') {
      wroll = d20.rollWithStatistics('1d6');
      wrath_total.add(wroll.finalResult);
    } else if (int.parse(cont[1]) >= 11 || int.parse(cont[1]) == -1){
      await ctx.sendMessage(MessageBuilder.content("But Caaaaarl that's heresy!"));
    } else {
      for (var i = 1; i <= int.parse(cont[1]); i++) {
        wroll = d20.rollWithStatistics('1d6');
        wrath_total.add(wroll.finalResult);
      }
    }
    print(wrath_total);

    /*var blah = MessageBuilder.content(
        total_dice.toString() + ' Total Successes: ' + tot_success.toString() +
            ' Wrath: ' + wrath_total.toString());*/
    final embed  = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';})
    ..addFooter((footer) {
      footer.text =
      'Machine Spirit v1.0.0 - Farsight ';})
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(
      name: 'Rolls:',
      content: total_dice.toString().replaceAll('[', '').replaceAll(']', ''),
      inline: false)
    ..addField(
      name: 'Successes:',
      content: tot_success.toString(),
      inline: true)
    ..addField(
      name: 'Wrath:',
      content: wrath_total.toString().replaceAll('[', '').replaceAll(']', ''),
      inline: true);


    var blah2 = await ctx.sendMessage(MessageBuilder.embed(embed));
  }
}

