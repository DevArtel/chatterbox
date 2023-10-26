import 'package:chatterbox/src/api/bot_facade.dart';
import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/dialog/flow_impl.dart';
import 'package:chatterbox/src/model/message_context.dart';
import 'package:chatterbox/src/storage/dialog_store.dart';
import 'package:chatterbox/src/utils/chat_utils.dart';
import 'package:chatterbox/src/utils/update_processing_utils.dart';
import 'package:collection/collection.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart' hide MessageContext;

class Chatterbox {
  final List<Flow> flows;

  final Bot bot;
  final ChatterboxStore store;
  late final FlowManager flowManager;

  Chatterbox(String botToken, this.flows, this.store) : bot = Bot(botToken) {
    print('[Chatterbox] constructor');
    flowManager = FlowManagerImpl(BotFacadeImpl(bot.api), store, flows);
    print('[Chatterbox] constructor 2');

    bot.onText(
      (ctx) {
        final message = ctx.message;
        print('[Chatterbox] on text ${message.text}');
        if (message.isCommand) {
          processCommand(ctx.update, (messageContext, command) async {
            print('[Chatterbox] Process command $command');
            _handleCommand(command, message, messageContext);
          });
        } else {
          processText(ctx.update, (messageContext) async {
            print('[Chatterbox] Process text message: $message');
            flowManager.handle(message, messageContext, null);
          });
        }
      },
    );

    bot.onCallbackQuery((ctx) => processCallbackQuery(ctx.update,  (messageContext, stepUri) async {
      print('[Chatterbox] Process callback query $stepUri');
      flowManager.handle(
        null,
        messageContext,
        stepUri,
      );
    }));

    print('[Chatterbox] constructor 3');
  }

  void startPolling() {
    bot.start();
  }

  void invokeFromWebhook(Map<String, dynamic> updateJson) {
    print('[Chatterbox] Received update from webhook: $updateJson');
    try {
      bot.handleUpdate(Update.fromJson(updateJson));
    } catch (error) {
      print('[Chatterbox] invokeFromWebhook failed: ${error.toString()}');
    }
  }

  void startFlowForMessage(Flow flow, Message message) {
    // TODO: Encode these args, because if stepUri is an argument it's not parsed properly
    List<String> args = parseArgs(message.text);
    int id = message.chat.id;

    flowManager.handle(
      null,
      MessageContext(userId: id, chatId: id, username: message.from?.username),
      flow.initialStep.uri.appendArgs(args),
    );
  }

  void _handleCommand(String command, Message message, MessageContext messageContext) {
    final flow = flows.whereType<CommandFlow>().firstWhereOrNull((flow) => flow.command == command);
    if (flow != null) {
      startFlowForMessage(flow, message);
    } else {
      print('[Chatterbox] Flow for $command not found!'); //todo Log.e
    }
  }
}
