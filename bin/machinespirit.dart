import 'package:machinespirit/species.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/nyxx_commander.dart'
    show CommandGroup, ICommandContext, ICommander;
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
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
  var cfg;
  try {
    var doc = await TomlDocument.load('config.toml');
    cfg = doc.toMap();
    ownerID = cfg['Owner']['ID'];
    prefix = cfg['Bot']['Prefix'];
    botID = cfg['Bot']['BotID'];

/*    var db = await Db.create('mongodb+srv://${cfg['DB']['User']}:${cfg['DB']['Pass']}@gemini.hjehy.mongodb.net/gemini?retryWrites=true&w=majority');
    await db.open();

    var coll = db.collection('machine_spirit');*/



    final bot = NyxxFactory.createNyxxWebsocket(cfg['Bot']['Token'], GatewayIntents.all,
      options: ClientOptions(guildSubscriptions: false))
    ..registerPlugin(Logging())
    ..registerPlugin(IgnoreExceptions());

    bot.onReady.listen((IReadyEvent e) {
      print('Connected to Discord');
      /*bot.setPresence(PresenceBuilder.of(
        game: Activity.of('with the Exterminatus button.',
        type: ActivityType.game,
        url: 'https://github.com/mediamagnet/Machine-Spirit')
      ));*/
      bot.setPresence(PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder(
              'with the Exterminatus Button', ActivityType.game,
              url: 'https://github.com/mediamagnet/Machine-Spirit')));

      bot.eventsWs.onMessageReceived.listen((IMessageReceivedEvent e) {
        if (e.message.content.contains(botID)) {
          e.message.createReaction(UnicodeEmoji('🤯'));
        }
      });
    });

    ICommander.create(bot, prefix)
      ..registerCommandGroup(CommandGroup(beforeHandler: checkForAdmin)
        ..registerSubCommand('shutdown', shutdownCommand))
      ..registerCommand('ping', pingCommand)
      ..registerCommand('info', infoCommand)
      ..registerCommand('roll', diceCommand)
      ..registerCommand('crit', critCommand)
      ..registerCommand('warp', warpCommand)
      ..registerCommand('help', helpCommand)
      ..registerCommand('scatter', scatterCommand);
      // ..registerCommand('test', speciesCommand)
      // ..registerCommand('prefix', prefixCommand);
  } catch (e) {
    print(e);
  }
  return cfg;
}

FutureOr<bool> checkForAdmin(ICommandContext context) async {
  if (ownerID != null) {
    return context.author.id == ownerID;
  }

  return false;
}
