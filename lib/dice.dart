import 'dart:math';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:toml/loader.dart';
import 'package:d20/d20.dart';



Future<void> diceCommand(CommandContext ctx, String content) async {
  var total_dice = List.empty(growable: true); // total rolled dice
  var tot_success; // total number of successes from your roll
  final d20 = D20();
  var cfg = await loadConfig('config.toml');
  var cont = content.replaceAll('${cfg['Bot']['Prefix']}roll ', '').split(' '); // message content
  var rolled; // dice rolls
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

    tot_success ??= 0; // Assign 0 if null


    final embed  = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';})
    ..addFooter((footer) {
      footer.text =
      'Machine Spirit v1.0.1 - Farsight ';})
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(
      name: 'Rolls:',
      content: total_dice.toString().replaceAll('[', '').replaceAll(']', ''),
      inline: false)
    ..addField(
      name: 'Successes:',
      content: tot_success.toString(),
      inline: true);


    var blah2 = await ctx.sendMessage(MessageBuilder.embed(embed));
  }
}

Future<void> critCommand(CommandContext ctx, String content) async {
  final d20 = D20();
  var rolled;
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  var table;
  var effect;
  var glory;

  rolled = d20.rollWithStatistics('1d66');
  print(rolled.finalResult);
  if (rolled.finalResult <= 11 && rolled.finalResult <= 16) {
    table = "Headshot: A well-aimed shot tears ragged chunks of bone and brain from the opponent's skull. The foe reels from such a violent strike, unable to focus.";
    effect = 'Target suffers +1d3 Wounds and is Staggered.';
    glory = 'Glory: +1 Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 21 && rolled.finalResult <= 23) {
    table = 'Brutal Rupture: Mangled flesh, crushed bone, and ruptured organs make your foe gasp in wretched pain.';
    effect = 'Target suffers +1d3 Wounds and is Hindered (1)';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 24 && rolled.finalResult <= 26) {
    table = "Ferocious Rending: The attack shreds the opponent's flesh to ribbons, leaving them open to attack.";
    effect = 'Target suffers +1d3 Wounds and is Vulnerable (2).';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 31 && rolled.finalResult <= 33) {
    table = 'Merciless Strike: A blow to the foe’s body steals the breath from their lungs, pulverising their innards with a nasty crunch.';
    effect = 'Target suffers a Mortal Wound.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 34 && rolled.finalResult <= 36) {
    table = 'Savage Attack: The assault leaves the opponent a mangled mess, slashing, burning, breaking or ripping into them with violent force.';
    effect = 'Target suffers one Mortal Wound. If the target survives they immediately acquire a Memorable Injury.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 41 && rolled.finalResult <= 43) {
    table = 'Vicious Vivisection: The fury of this blow causes horrific pain, dissecting pieces of the foe’s body in a scene of carnage and woe.';
    effect = 'Target suffers +1d3 Mortal Wounds.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 44 && rolled.finalResult <= 45) {
    table = 'Visceral Blow: Crimson showers the ground. The battlefield is a gory spectacle of spilled blood and unsure footing.';
    effect = 'Target suffers one Mortal Wound. Each character Engaged with the target must pass an Agility Test (DN 3) or fall Prone.';
    glory = 'For every Glory you spend the target suffers +1 Mortal Wound and you may choose one of the following additional effects: 💀 The target is Prone.  💀 The target suffers 2 Shock.';
  } else if (rolled.finalResult == 46) {
    table = 'Murderous Onslaught: A thunderous blow sends the target sprawling. Shattered ribs pierce organs, jets of blood spew from the wound, and the foe lies writhing in pain.';
    effect = 'Target suffers 1d3 + 1 Mortal Wounds and is knocked Prone.';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 51 && rolled.finalResult <= 53) {
    table = 'Overpowering Assault: A stunning blow sends the foe lurching away, senses blurred by the brutal impact.';
    effect = 'Target suffers 1d6 Shock and is Staggered. ';
    glory = '+2 Shock for every Glory you spend.';
  } else if (rolled.finalResult <= 54 && rolled.finalResult <= 55) {
    table = 'Crimson Ash: The attack sears into the foe, fusing flesh into a charred ruin. The assault wreathes the target in burning fury, making a smoldering mess of sinew and bone.';
    effect = 'Target suffers 1d3 + 1 Wounds and is On Fire.';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled.finalResult == 56) {
    table = 'Bone-shattering Impact: A crippling blow smashes the foe’s body, reducing arms, legs, and ribs to fractured splinters.';
    effect = 'Target suffers 1d3 + 1 Wounds.';
    glory = 'The target is Restrained and takes +1 Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 61 && rolled.finalResult <= 63) {
    table = 'Unspeakable Carnage: A truly grievous strike, the attack is a terrifying display of martial prowess. A geyser of gore erupts from the foe’s wound and ragged remnants of their body strewn are across the battlefield.';
    effect = 'Target suffers 1d3 + 3 Mortal Wounds.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled.finalResult <= 64 && rolled.finalResult <= 65) {
    table = 'Appalling Detonation: Ill fortune causes the blow to strike the foe’s volatile Wargear. A chain of explosions tears their body apart into grisly red mist.';
    effect = 'Target suffers 1d6 Wounds. If the target carried any explosives (such as grenades or ammunition), they detonate, inflicting 1d3 Mortal Wounds.';
    glory = 'For every point of Glory you spend, you can choose one of the following effects: 💀 The Critical Hit affects an additional target within 10 meters. 💀 All targets suffer +1 Wound.';
  } else if (rolled.finalResult <= 66) {
    table = 'Grisly Amputation: The foe’s limb is removed with extreme prejudice, leaving their body in a crimson arc.';
    effect = 'Target suffers one Mortal Wound and one limb is destroyed. Roll 1d6. On an even result, the activating player may choose the limb. On an odd result, the GM chooses.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  }

  final embed  = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';})
    ..addFooter((footer) {
      footer.text =
      'Machine Spirit v1.0.1 - Farsight ';})
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(
        name: 'Critical:',
        content: table,
        inline: false)
    ..addField(
        name: 'Effect:',
        content: effect,
        inline: false)
    ..addField(
      name: 'Glory',
      content: glory,
      inline: false);


  var blah2 = await ctx.sendMessage(MessageBuilder.embed(embed));
}