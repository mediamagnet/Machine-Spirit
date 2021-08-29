import 'dart:io';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:machinespirit/utils.dart' as utils;

Future<void> pingCommand(CommandContext ctx, String content) async {
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

  embed
    .replaceField(
        name: 'Message roundup time',
        content: '${stopwatch.elapsedMilliseconds} ms',
        inline: true);

  await message.edit(MessageBuilder.embed(embed));
}

Future<void> infoCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = ctx.client.self.tag;
      author.iconUrl = ctx.client.self.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text =
      'Nyxx 1.1.0-dev | Shard [${ctx.shardId + 1}] of [${ctx.client.shards}] | ${utils.dartVersion}';
    })
    ..color = color
    ..addField(
        name: 'Uptime', content: ctx.client.uptime.inMinutes, inline: true)
    ..addField(
        name: 'DartVM memory usage',
        content:
        '${(ProcessInfo.currentRss / 1024 / 1024).toStringAsFixed(2)} MB',
        inline: true)
    ..addField(
        name: 'Created at', content: ctx.client.app.createdAt, inline: true)
    ..addField(
        name: 'Guild count', content: ctx.client.guilds.count, inline: true)
    ..addField(
        name: 'Users count', content: ctx.client.users.count, inline: true)
    ..addField(
        name: 'Channels count',
        content: ctx.client.channels.count,
        inline: true)
    ..addField(
        name: 'Users in voice',
        content: ctx.client.guilds.values
            .map((g) => g.voiceStates.count)
            .reduce((f, s) => f + s),
        inline: true)
    ..addField(name: 'Shard count', content: ctx.client.shards, inline: true)
    ..addField(
        name: 'Cached messages',
        content: ctx.client.channels
            .find((item) => item is TextChannel)
            .cast<TextChannel>()
            .map((e) => e.messageCache.count)
            .fold(0, (first, second) => (first as int) + second),
        inline: true);
  await ctx.message.delete();
  await ctx.sendMessage(MessageBuilder.embed(embed));
}