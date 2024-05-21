// import 'dart:io';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/nyxx_commander.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
import 'package:machinespirit/utils.dart' as utils;
import 'package:time_ago_provider/time_ago_provider.dart' show formatFull;

Future<void> pingCommand(ICommandContext ctx, String content) async {
  await ctx.message.delete();
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  final gatewayDelayInMilis = ctx.client.shardManager.shards
      .firstWhere((element) => element.id == ctx.shardId)
      .gatewayLatency
      .inMilliseconds;
  final stopwatch = Stopwatch()..start();

  final embed = EmbedBuilder()
    ..color = color
    ..addField(
        name: 'Gateway latency',
        content: '$gatewayDelayInMilis ms',
        inline: true)
    ..addField(
        name: 'Message roundup time', content: 'Pending...', inline: true);

  final message = await ctx.sendMessage(MessageBuilder.embed(embed));

  embed.replaceField(
      name: 'Message roundup time',
      content: '${stopwatch.elapsedMilliseconds} ms',
      inline: true);

  await message.edit(MessageBuilder.embed(embed));
}

Future<void> infoCommand(ICommandContext ctx, String content) async {
  await ctx.message.delete();
  await ctx.reply(await infoGenericCommand(ctx.client));
}

Future<MessageBuilder> infoGenericCommand(INyxxWebsocket client,
    [int shardId = 0]) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = client.self.tag;
      author.iconUrl = client.self.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text = 'Machine Spirit v 1.6.0 Voidblade';
    })
    ..color = color
    ..addField(
        name: 'Cached Guilds', content: client.guilds.length, inline: true)
    ..addField(name: 'Cached Users', content: client.users.length, inline: true)
    ..addField(
        name: 'Cached Channels', content: client.channels.length, inline: true)
    ..addField(
        name: 'Cached Voice States',
        content: client.guilds.values
            .map((g) => g.voiceStates.length)
            .reduce((f, s) => f + s),
        inline: true)
    ..addField(name: 'Shard count', content: client.shards, inline: true)
    ..addField(
        name: 'Cached messages',
        content: client.channels.values
            .whereType<ITextChannel>()
            .map((e) => e.messageCache.length)
            .fold(0, (first, second) => (first as int) + second),
        inline: true)
    ..addField(
        name: 'Memory usage (current/RSS)',
        content: utils.getMemoryUsageString(),
        inline: true)
    ..addField(
        name: 'Member count (online/total)',
        content: utils.getApproxMemberCount(client),
        inline: true)
    ..addField(name: 'Uptime', content: formatFull(client.startTime));

  return ComponentMessageBuilder()
    ..embeds = [embed]
    ..componentRows = [
      [
        LinkButtonBuilder(
            "Click me, bet you won't", 'https://i.imgur.com/8N0zWyp.mp4')
      ]
    ];
}

Future<void> helpCommand(ICommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = ctx.client.self.tag;
      author.iconUrl = ctx.client.self.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text = 'Machine Spirit v 1.6.0 Voidblade';
    })
    ..color = color
    ..addField(
        name: 'prefix',
        content: 'My current prefix is `${utils.conf('Bot/Prefix')}`')
    ..addField(
        name: '${utils.conf('Bot/Prefix')}roll',
        content: 'Roll the specified amount of dice, up to 50',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}crit',
        content: 'Roll for a critical effect',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}warp',
        content:
            'Roll for a warp effect, add 1-4 for each additional 1 rolled in the warp check.',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}scatter',
        content: 'Cause Scatter dice are fun',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}info',
        content: 'sends info about the bot',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}ping',
        content: 'Sends current bot latency',
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}help',
        content: "You're reading it.",
        inline: false)
    ..addField(
        name: '${utils.conf('Bot/Prefix')}shutdown',
        content: 'Shuts the bot down',
        inline: false);
  await ctx.message.delete();
  await ctx.sendMessage(MessageBuilder.embed(embed));
}
