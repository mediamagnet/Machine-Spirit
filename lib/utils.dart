import 'dart:io' show Platform, ProcessInfo;

import 'package:nyxx/nyxx.dart';
import 'package:toml/toml.dart';
// import 'dart:convert';

DateTime _approxMemberCountLastAccess = DateTime.utc(2005);
int _approxMemberCount = -1;
int _approxMemberOnline = -1;

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

String getMemoryUsageString() {
  final current = (ProcessInfo.currentRss / 1024 / 1024).toStringAsFixed(2);
  final rss = (ProcessInfo.maxRss / 1024 / 1024).toStringAsFixed(2);
  return '$current/${rss}MB';
}

String getApproxMemberCount(INyxxWebsocket client) {
  if (DateTime.now().difference(_approxMemberCountLastAccess).inMinutes > 5 || _approxMemberCount == -1) {
    Future(() async {
      var amc = 0;
      var amo = 0;

      for (final element in client.guilds.values) {
        final guildPreview = await element.fetchGuildPreview();

        amc += guildPreview.approxMemberCount;
        amo += guildPreview.approxOnlineMembers;
      }

      _approxMemberCount = amc;
      _approxMemberOnline = amo;
    });
  }

  if (_approxMemberCount == -1 || _approxMemberOnline == -1) {
    return 'Loading...';
  }

  return '$_approxMemberOnline/$_approxMemberCount';
}

