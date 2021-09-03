import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart'
    show CommandContext, CommandGroup, Commander;
import 'package:toml/loader/fs.dart';
import 'dart:async';
// import 'package:cron/cron.dart';
import 'package:machinespirit/admin.dart';
import 'package:machinespirit/util.dart';
import 'package:machinespirit/dice.dart';

var ownerID;
var launch = DateTime.now();
var prefix;
var botID;

Future main(List<String> arguments) async {
  // final cron = Cron();
  FilesystemConfigLoader.use();
  var cfg;
  try {
    cfg = await loadConfig('config.toml');
    ownerID = cfg['Owner']['ID'];
    prefix = cfg['Bot']['Prefix'];
    botID = cfg['Bot']['ID'];

    final bot = Nyxx(cfg['Bot']['Token'], GatewayIntents.all);

    bot.onReady.listen((ReadyEvent e) {
      print('Connected to Discord');
      /*bot.setPresence(PresenceBuilder.of(
        game: Activity.of('with the Exterminatus button.',
        type: ActivityType.game,
        url: 'https://github.com/mediamagnet/Machine-Spirit')
      ));*/
      bot.setPresence(PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder(
              'with the Exterminatus Button', ActivityType.game)));

      bot.onMessageReceived.listen((MessageReceivedEvent e) {
        if (e.message.content.contains(botID)) {
          e.message.createReaction(UnicodeEmoji('🤯'));
        }
      });
    });

    Commander(bot, prefix: prefix)
      ..registerCommandGroup(CommandGroup(beforeHandler: checkForAdmin)
        ..registerSubCommand('shutdown', shutdownCommand))
      ..registerCommand('ping', pingCommand)
      ..registerCommand('info', infoCommand)
      ..registerCommand('roll', diceCommand)
      ..registerCommand('crit', critCommand)
      ..registerCommand('warp', warpCommand)
      ..registerCommand('help', helpCommand);
  } catch (e) {
    print(e);
  }
  return cfg;
}

Future<bool> checkForAdmin(CommandContext context) async {
  if (ownerID != null) {
    return context.author.id == ownerID;
  }

  return false;
}
