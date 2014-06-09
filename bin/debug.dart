import '../lib/irc.dart';
import 'dart:io';

void main() {
    BotConfig config = new BotConfig(host: "irc.esper.net", port: 6667, nickname: "DartBot", username: "DartBot", synchronous: true);

    CommandBot bot = new CommandBot(config, prefix: ".");

    bot.on(Events.Line).listen((LineEvent event) {
        print(">> ${event.message}");
    });

    bot.on(Events.Send).listen((SendEvent event) {
        print("<< ${event.message}");
    });

    bot.onMessage((MessageEvent event) => print("<${event.target}><${event.from}> ${event.message}"));

    bot.whenReady((ReadyEvent event) {
        event.join("#directcode");
    });

    bot.command("help").listen((CommandEvent event) {
        event.reply("> ${Color.BLUE}Commands${Color.RESET}: ${bot.commandNames().join(', ')}");
    });

    bot.command("dart").listen((CommandEvent event) {
        event.reply("> Dart VM: ${Platform.version}");
    });

    bot.command("join").listen((CommandEvent event) {
        print(event.args);
        if (event.args.length != 1) {
            event.reply("Usage: join <channel>");
        } else {
            bot.join(event.args[0]);
        }
    });

    bot.command("part").listen((CommandEvent event) {
        if (event.args.length != 1) {
            event.reply("Usage: part <channel>");
        } else {
            bot.client().part(event.args[0]);
        }
    });

    bot.command("quit").listen((CommandEvent event) {
        bot.disconnect();
    });

    bot.onJoin((JoinEvent event) {
        if (event.isBot()) {
            print("Joined ${event.channel.name}");
        } else {
            print("<${event.channel.name}> ${event.user} has joined");
        }
    });

    bot.on(Events.Part).listen((PartEvent event) {
        print("<${event.channel.name}> ${event.user} has left");
    });

    bot.connect();
}