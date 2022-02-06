// import 'package:machinespirit/species.dart';
// import 'package:mongo_dart/mongo_dart.dart';
import 'package:logging/logging.dart';
import 'package:machinespirit/diceslash.dart';
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
import 'package:machinespirit/utils.dart' as utils;

var ownerID;
var launch = DateTime.now();
var prefix;
var botID;
var botToken;

late INyxxWebsocket bot;

Future main(List<String> arguments) async {
  await utils.tomlFile('config.toml');
  // final cron = Cron();
  Logger.root.level = Level.INFO;
  try {

    ownerID = utils.conf('Owner/ID');
    prefix = utils.conf('Bot/Prefix');
    botID = utils.conf('Bot/ID');
    botToken = utils.conf('Bot/Token');





/*    var db = await Db.create('mongodb+srv://${cfg['DB']['User']}:${cfg['DB']['Pass']}@gemini.hjehy.mongodb.net/gemini?retryWrites=true&w=majority');
    await db.open();

    var coll = db.collection('machine_spirit');*/



    bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
    ..registerPlugin(Logging())
    ..registerPlugin(IgnoreExceptions());

    await bot.connect();

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
          e.message.createReaction(UnicodeEmoji('🟥'));
        }
      });
    });


    ICommander.create(bot, utils.prefixHandler)
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

    IInteractions.create(WebsocketInteractionBackend(bot))
      ..registerSlashCommand(SlashCommandBuilder('roll', 'roll the dice', [
        CommandOptionBuilder(CommandOptionType.string, 'dice', 'Number of dice to roll')
      ], guild: null)..registerHandler(diceSlashCommand))
      ..registerSlashCommand(SlashCommandBuilder('warp', 'Roll on the Perils of the Warp table', [
        CommandOptionBuilder(CommandOptionType.integer, 'extra', 'Number of extra warp dice to roll, IF NONE PUT 0')
      ], guild: null)..registerHandler(warpSlashCommand))
    ..syncOnReady(syncRule: ManualCommandSync(sync: utils.getSyncCommandsOrOverride(true)));
  } catch (e) {
    print(e);
  }
}

FutureOr<bool> checkForAdmin(ICommandContext context) async {
  if (ownerID != null) {
    return context.author.id == ownerID;
  }

  return false;
}
