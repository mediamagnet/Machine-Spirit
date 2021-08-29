import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart' show CommandContext, CommandGroup, Commander;
import 'package:toml/loader/fs.dart';
import 'dart:async';
import 'package:cron/cron.dart';


var ownerID;
var launch = DateTime.now();
var prefix;

Future main(List<String> arguments) async {
  final cron = Cron();
  FilesystemConfigLoader.use();
  var cfg;
  try {
    cfg = await loadConfig('config.toml');
    ownerID = cfg['Owner']['ID'];
    prefix = cfg['Bot']['Prefix'];

    final bot = Nyxx(cfg['Bot']['Token'], GatewayIntents.all);

    bot.onReady.listen((ReadyEvent e) {
      print('Connected to Discord');
      bot.setPresence(PresenceBuilder.of(
        game: Activity.of('with the Exterminatus button.',
        type: ActivityType.game,
        url:)
      ));
    });
  } catch (e){
    print(e);
  }
  return cfg;
}