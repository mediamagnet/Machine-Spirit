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
  var cont = content
      .replaceAll('${cfg['Bot']['Prefix']}roll ', '')
      .split(' '); // message content
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

    total_dice.forEach(
        (e) => explode.update(e.toString(), (x) => x + 1, ifAbsent: () => 1));
    if (explode.containsKey('4') ||
        explode.containsKey('5') ||
        explode.containsKey('6')) {
      print(explode);

      var sixes = (explode['6'] ?? 0) * 2;
      tot_success = (explode['4'] ?? 0) + (explode['5'] ?? 0) + sixes;
    }

    tot_success ??= 0; // Assign 0 if null

    final embed = EmbedBuilder()
      ..color = color
      ..addAuthor((author) {
        author.name = ctx.message.author.username;
        author.iconUrl = ctx.message.author.avatarURL();
        author.url = 'https://github.com/mediamagnet/Machine-Spirit';
      })
      ..addFooter((footer) {
        footer.text = 'Machine Spirit v1.0.1 - Farsight ';
      })
      ..thumbnailUrl = ctx.client.self.avatarURL()
      ..addField(
          name: 'Rolls:',
          content:
              total_dice.toString().replaceAll('[', '').replaceAll(']', ''),
          inline: false)
      ..addField(
          name: 'Successes:', content: tot_success.toString(), inline: true);
    await ctx.sendMessage(MessageBuilder.embed(embed));
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

  var roll1 = d20.rollWithStatistics('1d6');
  var roll2 = d20.rollWithStatistics('1d6');

  rolled = roll1.finalResult * 10 + roll2.finalResult;
  print(rolled);
  if (rolled <= 11 && rolled <= 16) {
    table =
        "Headshot: A well-aimed shot tears ragged chunks of bone and brain from the opponent's skull. The foe reels from such a violent strike, unable to focus.";
    effect = 'Target suffers +1d3 Wounds and is Staggered.';
    glory = 'Glory: +1 Wound for every Glory you spend.';
  } else if (rolled <= 21 && rolled <= 23) {
    table =
        'Brutal Rupture: Mangled flesh, crushed bone, and ruptured organs make your foe gasp in wretched pain.';
    effect = 'Target suffers +1d3 Wounds and is Hindered (1)';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled <= 24 && rolled <= 26) {
    table =
        "Ferocious Rending: The attack shreds the opponent's flesh to ribbons, leaving them open to attack.";
    effect = 'Target suffers +1d3 Wounds and is Vulnerable (2).';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled <= 31 && rolled <= 33) {
    table =
        'Merciless Strike: A blow to the foe’s body steals the breath from their lungs, pulverising their innards with a nasty crunch.';
    effect = 'Target suffers a Mortal Wound.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled <= 34 && rolled <= 36) {
    table =
        'Savage Attack: The assault leaves the opponent a mangled mess, slashing, burning, breaking or ripping into them with violent force.';
    effect =
        'Target suffers one Mortal Wound. If the target survives they immediately acquire a Memorable Injury.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled <= 41 && rolled <= 43) {
    table =
        'Vicious Vivisection: The fury of this blow causes horrific pain, dissecting pieces of the foe’s body in a scene of carnage and woe.';
    effect = 'Target suffers +1d3 Mortal Wounds.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled <= 44 && rolled <= 45) {
    table =
        'Visceral Blow: Crimson showers the ground. The battlefield is a gory spectacle of spilled blood and unsure footing.';
    effect =
        'Target suffers one Mortal Wound. Each character Engaged with the target must pass an Agility Test (DN 3) or fall Prone.';
    glory =
        'For every Glory you spend the target suffers +1 Mortal Wound and you may choose one of the following additional effects: 💀 The target is Prone.  💀 The target suffers 2 Shock.';
  } else if (rolled == 46) {
    table =
        'Murderous Onslaught: A thunderous blow sends the target sprawling. Shattered ribs pierce organs, jets of blood spew from the wound, and the foe lies writhing in pain.';
    effect = 'Target suffers 1d3 + 1 Mortal Wounds and is knocked Prone.';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled <= 51 && rolled <= 53) {
    table =
        'Overpowering Assault: A stunning blow sends the foe lurching away, senses blurred by the brutal impact.';
    effect = 'Target suffers 1d6 Shock and is Staggered. ';
    glory = '+2 Shock for every Glory you spend.';
  } else if (rolled <= 54 && rolled <= 55) {
    table =
        'Crimson Ash: The attack sears into the foe, fusing flesh into a charred ruin. The assault wreathes the target in burning fury, making a smoldering mess of sinew and bone.';
    effect = 'Target suffers 1d3 + 1 Wounds and is On Fire.';
    glory = '+1 Wound for every Glory you spend.';
  } else if (rolled == 56) {
    table =
        'Bone-shattering Impact: A crippling blow smashes the foe’s body, reducing arms, legs, and ribs to fractured splinters.';
    effect = 'Target suffers 1d3 + 1 Wounds.';
    glory =
        'The target is Restrained and takes +1 Wound for every Glory you spend.';
  } else if (rolled <= 61 && rolled <= 63) {
    table =
        'Unspeakable Carnage: A truly grievous strike, the attack is a terrifying display of martial prowess. A geyser of gore erupts from the foe’s wound and ragged remnants of their body strewn are across the battlefield.';
    effect = 'Target suffers 1d3 + 3 Mortal Wounds.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  } else if (rolled <= 64 && rolled <= 65) {
    table =
        'Appalling Detonation: Ill fortune causes the blow to strike the foe’s volatile Wargear. A chain of explosions tears their body apart into grisly red mist.';
    effect =
        'Target suffers 1d6 Wounds. If the target carried any explosives (such as grenades or ammunition), they detonate, inflicting 1d3 Mortal Wounds.';
    glory =
        'For every point of Glory you spend, you can choose one of the following effects: 💀 The Critical Hit affects an additional target within 10 meters. 💀 All targets suffer +1 Wound.';
  } else if (rolled <= 66) {
    table =
        'Grisly Amputation: The foe’s limb is removed with extreme prejudice, leaving their body in a crimson arc.';
    effect =
        'Target suffers one Mortal Wound and one limb is destroyed. Roll 1d6. On an even result, the activating player may choose the limb. On an odd result, the GM chooses.';
    glory = '+1 Mortal Wound for every Glory you spend.';
  }

  final embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text = 'Machine Spirit v1.0.1 - Farsight ';
    })
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(name: 'Critical:', content: table, inline: false)
    ..addField(name: 'Effect:', content: effect, inline: false)
    ..addField(name: 'Glory', content: glory, inline: false);

  await ctx.sendMessage(MessageBuilder.embed(embed));
}

Future<void> warpCommand(CommandContext ctx, String content) async {
  final d20 = D20();
  var rolled;
  var cfg = await loadConfig('config.toml');
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  var warp;
  var msgContent =
      ctx.message.content.replaceAll('${cfg['Bot']['Prefix']}warp ', '');
  var extraWarp;

  if (msgContent == '1') {
    extraWarp = 10;
  } else if (msgContent == '2') {
    extraWarp = 20;
  } else if (msgContent == '3') {
    extraWarp = 30;
  } else if (msgContent == '4') {
    extraWarp = 40;
  };

  var roll1 = d20.rollWithStatistics('1d6');
  var roll2 = d20.rollWithStatistics('1d6');

  rolled = roll1.finalResult * 10 + roll2.finalResult;

  if (extraWarp == 10) {
    rolled = rolled + 10;
  } else if (extraWarp == 20) {
    rolled = rolled + 20;
  } else if (extraWarp == 30) {
    rolled = rolled + 30;
  } else if (extraWarp == 40) {
    rolled = rolled + 40;
  };

  if (rolled <= 11 && rolled <= 12) {
    warp =
        'FLICKERING LIGHTS: For a brief moment, all light sources flicker and go out.';
  } else if (rolled <= 13 && rolled <= 14) {
    warp =
        'HOARFROST: The temperature instantly drops 20 degrees, and all surfaces within 25 m of you are coated with a thin rime of frost. The temperature returns to normal over the course of a minute. The frost is treated as Difficult Terrain. Anyone who rolls a Complication whilst on the frost falls Prone.';
  } else if (rolled <= 15 && rolled <= 16) {
    warp =
        'ROILING MIST: A clammy mist roils up from the ground, surrounding you in a 25 m radius. The mist obscures vision and distorts sounds with weird echoes for 1 Round. All Tests made inside the mist that rely on sight or hearing are made at +2 DN.';
  } else if (rolled <= 21 && rolled <= 22) {
    warp =
        'WHISPERS IN THE DARK: All light sources within 25 m of you grow dim and shadows pool thickly. Sinister whispers echo, and anyone who can hear them must make a successful DN 3 Corruption Test. Any who fail the Corruption roll are Vulnerable [2] for 1 Round.';
  } else if (rolled <= 23 && rolled <= 24) {
    warp =
        'WARP SPECTRES: For roughly a minute, ethereal images of strange creatures move in and out of existence within 25m of you. These apparitions move awkwardly, passing through objects and the living alike, seemingly unaware of the real world. All animals immediately flee the area, and any sentient being who witnesses the apparitions must make a DN 3 Fear Test.';
  } else if (rolled <= 25 && rolled <= 26) {
    warp =
        'TEARS OF THE MARTYR: All paintings, statues, or equivalent effigies within 100 m of you begin to weep blood. If no such features exist in range, then walls or similar surfaces begin to drip with blood. The bleeding persists for 1 minute. All sentient creatures that witness this event must make a DN 3 Fear Test. ';
  } else if (rolled <= 31 && rolled <= 32) {
    warp =
        'SINISTER CHORUS: A sinister chorus or low laughter swirls around you and those in the vicinity. All sentient creatures within 25 m must make a successful DN 3 Willpower Test or are Hindered (1) for one Round. The GM gains 1 Ruin. ';
  } else if (rolled <= 33 && rolled <= 34) {
    warp =
        'THE WATCHING: An overwhelming paranoia of something watching creeps over you and everyone within 20 m. Lesser creatures and animals cower in fear, while sentient creatures must make a successful DN 4 Willpower Test or suffer an uncontrollable compunction to second-guess all their actions — they are Hindered (2). This effect lasts for the remainder of the scene.';
  } else if (rolled <= 35 && rolled <= 36) {
    warp =
        'MIASMA OF DECAY: The stench of rotting meat and decaying flesh rises from the ground within 25 m of you. All creatures within range must make a DN 3 Toughness Test, including those protected by technological breathing apparatus. Those who fail suffer 1 Shock.warp =';
  } else if (rolled <= 41 && rolled <= 42) {
    warp =
        'BANSHEE SCREAM: A mighty roar akin to a sonic boom crashes through the air. Lesser animal lifeforms (insects, rodents, avians, etc.) within 25 m are instantly killed. All others suffer 1d3 Shock and must make a successful DN 3 Toughness Test or are Staggered.';
  } else if (rolled <= 43 && rolled <= 44) {
    warp =
        'UNNATURAL BLOODLUST: All creatures within 15 m of you suffer from a ringing in their ears and taste the bitterness of iron. During the next round, all melee attacks they make gain +1 ED. ';
  } else if (rolled <= 45 && rolled <= 46) {
    warp =
        'THE EARTH PROTESTS: The ground within 50 m of you is jolted by a sudden but brief earthquake. The tremor causes no real damage, but all in range must make a successful DN 3 Agility Test or be thrown Prone and suffer 1 Shock.';
  } else if (rolled <= 51 && rolled <= 52) {
    warp =
        'LIFE DRAIN: A numbing cold washes out from you, leeching the very life essence of those nearby. Every living creature within 25 m immediately suffers 1d3 Shock and all lesser life forms (plants, avians, insects, etc.) wither and die.';
  } else if (rolled <= 53 && rolled <= 54) {
    warp =
        'VISIONS OF POSSIBILITY: An awful droning buzz surrounds you, drowning out all speech. The drone penetrates the mind. All creatures with the PSYKER Keyword within 10 m must make a DN 4 Intellect Test. Those who fail are Staggered and suffer 1d3 Shock. Those who succeed gain 1 Wrath.';
  } else if (rolled <= 55 && rolled <= 56) {
    warp =
        'PSYCHIC BACKLASH: Lurid-pink Warp lightning dances across your flesh. You suffer 1d3+2 Shock.';
  } else if (rolled <= 61 && rolled <= 62) {
    warp =
        'THE VEIL THINS: The air within 25 m of you thins, causing living creatures to suffer shortness of breath and dizziness. All creatures without artificial breathing apparatus are Hindered (2) for 1 minute. In addition, 1 Wrath Dice must be added to all Psychic Mastery (Wil) Tests for the remainder of the scene.';
  } else if (rolled <= 63 && rolled <= 64) {
    warp =
        'WARP-TOUCHED AURA: The mystical energies of the Warp wash over you and infuse the landscape for 25 m in every direction. All creatures in the area suffer 1d3 Shock. In addition, the invisible energies flowing through this area greatly increase the potency of psychic phenomena — 1 Wrath Dice must be added to all Psychic Mastery (Wil) for the remainder of the scene.';
  } else if (rolled <= 65 && rolled <= 66) {
    warp =
        'SURGING WARP ENERGIES: The air seems to shimmer and distort. All creatures within 25 m of you suffer 1d6 Shock and the GM gains 1 Ruin. For the remainder of the scene, all Wrath Dice rolled as part of a Psychic Mastery Test that don’t result in a 1 or a 6 must be rerolled once. ';
  } else if (rolled <= 71 && rolled <= 72) {
    warp =
        'UNNATURAL EFFUSIONS: You vomit foul otherworldly materials uncontrollably, far more than your body could ever produce. You suffer 1d6 Shock and are Restrained for 1d6 Rounds. ';
  } else if (rolled <= 73 && rolled <= 74) {
    warp =
        'THE CRAWLING: You are overcome with the sensation of tiny creatures moving just under your skin. You immediately suffer 1d6+1 Shock and must increase the DN of all Tests by 2 for the remainder of the scene. ';
  } else if (rolled <= 75 && rolled <= 76) {
    warp =
        'TWISTED FLESH: The energies of the Warp unleash a corruptive force on your physical form and all creatures within 10m. All affected characters must make a DN 7 Corruption Test. Those who fail gain 1d3 Corruption (instead of just one) and suffer 1 Mortal Wound.';
  } else if (rolled <= 81 && rolled <= 82) {
    warp =
        'GRAVE CHILL: The environment around you grows numbingly cold, a supernatural chill suffusing every surface with glistening ice. You and every creature within 50 m suffer a -1 to Agility and Strength for the rest of the scene. In addition, all affected creatures must make a successful DN 5 Toughness Test or suffer 1 Mortal Wound.';
  } else if (rolled <= 83 && rolled <= 84) {
    warp =
        'THE SUMMONING: A portal is torn open between the Materium and the Warp. A Daemon appears within 25 m of you. The exact location and nature of this daemon is at the GM’s discretion. The daemonic entity immediately attacks the nearest target. The daemon returns to the Warp after 3 rounds, or when it has been destroyed.';
  } else if (rolled <= 85 && rolled <= 86) {
    warp =
        'VOICES FROM THE BEYOND: All creatures within 25 m of you hear harsh, guttural voices close to their ear, though their words are seemingly gibberish. All characters within 10 m must make a DN 5 Fear Test. All sentient characters in range are Staggered until the end of the scene.';
  } else if (rolled <= 91 && rolled <= 92) {
    warp =
        'DARK PASSENGER: A daemon enters your mind. The daemon looks out through your eyes, reporting to whatever cruel entity rules it, and may attempt to influence your actions whenever you roll a Complication. It may whisper foul secrets, make disturbing comments, or otherwise make itself known for the remainder of your existence unless expelled. The GM gains one Ruin, and may rule that the daemon takes other actions. See the Daemonic Possession sidebar on page 264 (or use command !possesion) for more information.';
  } else if (rolled <= 93 && rolled <= 94) {
    warp =
        'WRITHING DISFIGUREMENT: You are wracked with pain, collapsing to the ground. You suffer 1d6 Shock and gain 1d3+1 Corruption. You must roll on the Minor Mutations table (p.288). ';
  } else if (rolled <= 95 && rolled <= 96) {
    warp =
        'SPECTRAL GALE: Swirling vortexes of misty, inhuman faces sweep past you and spin away in all directions. The distorted images cackle in maniacal glee, and all mortals who hear them struggle to keep order to their thoughts. All living creatures within 25 m of you must make a DN 7 Fear Test.';
  } else if (rolled <= 101 && rolled <= 102) {
    warp =
        'EYE OF THE GODS: Your mind fleetingly draws the gaze of one of the Ruinous Powers. You and any mortals within 20m must make a DN 7 Corruption Test. Those who succeed gain 1 Wrath Point. ';
  } else if (rolled <= 103 && rolled <= 104) {
    warp =
        'BLOOD RAIN: A hot and sticky blood rain falls in an 8 m radius centred on you. The supernatural storm starts slowly, but quickly builds to a torrent lasting only minutes. Any creature whose flesh is touched by this blood must make a successful DN 7 Willpower Test or become Frenzied. The awful stench of the blood will seep into any item , and may make surfaces slick and slippery.';
  } else if (rolled <= 105 && rolled <= 106) {
    warp =
        'PSYCHIC OVERLOAD: Streaming Warp energy bursts from your eyes and mouth, flashing in all directions and penetrating all living creatures surrounding you. You suffer 2d6 Mortal Wounds and gain 1d3 points of Corruption. All other creatures within 10 m suffer 1d3 Mortal Wounds and must make a successful DN 7 Toughness Test or are Blinded';
  }

  final embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text = 'Machine Spirit v1.0.1 - Farsight ';
    })
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(name: 'Rolled value:', content: rolled, inline: false)
    ..addField(name: 'Perils of the Warp:', content: warp, inline: false);

  await ctx.sendMessage(MessageBuilder.embed(embed));
}

Future<void> scatterCommand(CommandContext ctx, String content) async {
  final d20 = D20();
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));

  var roll1 = d20.rollWithStatistics('1d9');
  var roll2 = d20.rollWithStatistics('1d6');

  var rolled1 = scatterFace(roll1.finalResult);
  var rolled2 = roll2.finalResult;
  var scattered = rolled1;
  print(scattered);

  if (scattered == UnicodeEmoji('🎯')) {
    rolled2 = 0;
  }

  final embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = ctx.message.author.username;
      author.iconUrl = ctx.message.author.avatarURL();
      author.url = 'https://github.com/mediamagnet/Machine-Spirit';
    })
    ..addFooter((footer) {
      footer.text = 'Machine Spirit v1.0.1 - Farsight ';
    })
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..addField(name: 'Direction', content: scattered, inline: false)
    ..addField(name: 'Feet:', content: rolled2, inline: false);

  await ctx.sendMessage(MessageBuilder.embed(embed));
}

// :arrow_down: :arrow_left: :arrow_right: :arrow_up: :arrow_upper_left: :arrow_upper_right: :arrow_lower_left: :arrow_lower_right: :dart:
UnicodeEmoji scatterFace(int face) {
  var newFace;
  switch (face) {
    case 1:
      newFace = '⬅';
      break;
    case 2:
      newFace = '➡';
      break;
    case 3:
      newFace = '⬆';
      break;
    case 4:
      newFace = '⬇';
      break;
    case 5:
      newFace = '↖';
      break;
    case 6:
      newFace = '↗';
      break;
    case 7:
      newFace = '↘';
      break;
    case 8:
      newFace = '↙';
      break;
    case 9:
      newFace = '🎯';
      break;
  }

  print(newFace);
  return UnicodeEmoji(newFace);
}