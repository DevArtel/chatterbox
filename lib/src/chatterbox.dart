import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/src/api/bot_facade.dart';
import 'package:chatterbox/src/utils/chat_utils.dart';
import 'package:chatterbox/src/utils/televerse_extensions.dart';
import 'package:chatterbox/src/utils/update_processing_utils.dart';
import 'package:collection/collection.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart' hide MessageContext;

class Chatterbox {
  final List<Flow> flows;

  final Bot _bot;
  final PendingMessagesStore store;
  late final FlowManager _flowManager;

  Chatterbox({required String botToken, required this.flows, required this.store}) : _bot = Bot(botToken) {
    _flowManager = FlowManagerImpl(BotFacadeImpl(_bot.api), store, flows);

    _bot.onText(
      (ctx) {
        final message = ctx.message;
        if (message.isCommand) {
          processCommand(ctx.update, (messageContext, command) async {
            print('[Chatterbox] Process command /$command');
            await store.clearPending(messageContext.userId);
            _handleCommand(command, message, messageContext);
          });
        } else {
          processText(ctx.update, (messageContext) async {
            print('[Chatterbox] Process text message: $message');
            _flowManager.handle(messageContext, null);
          });
        }
      },
    );

    _bot.onCallbackQuery((ctx) => processCallbackQuery(ctx.update, (messageContext, stepUri) async {
          print('[Chatterbox] Process callback query $stepUri');
          _flowManager.handle(messageContext, stepUri);
        }));

    _bot.onPreCheckoutQuery((ctx) => processPreCheckoutQuery(ctx.update, (messageContext, stepUri) async {
          print('[Chatterbox] Process pre checkout query $stepUri');
          _flowManager.handle(messageContext, stepUri);
        }));

    _bot.onSuccessfulPayment((ctx) => processSuccessfulPayment(ctx.update, (messageContext) async {
          print('[Chatterbox] Process successful payment ${messageContext.successfulPayment}');
          _flowManager.handle(messageContext);
        }));

    _bot.onPhoto((ctx) => processPhoto(ctx.update, (messageContext) async {
          print('[Chatterbox] on photo, count: ${messageContext.mediaFiles?.length ?? 0}');
          _flowManager.handle(messageContext);
        }));

    _bot.onVideo((ctx) => processVideo(ctx.update, (messageContext) async {
          print('[Chatterbox] on video, count: ${messageContext.mediaFiles?.length ?? 0}');
          _flowManager.handle(messageContext);
        }));

    _bot.onSticker((ctx) => processSticker(ctx.update, (messageContext) async {
          print('[Chatterbox] on sticker, count: ${messageContext.mediaFiles?.length ?? 0}');
          _flowManager.handle(messageContext);
        }));
    //
    // _bot.onAnimation((ctx) => processPhoto(ctx.update, (messageContext) async {
    //       print('[Chatterbox] on animation, count: ${messageContext.mediaFiles?.length ?? 0}');
    //       _flowManager.handle(messageContext);
    //     }));
    //
    // _bot.onAudio((ctx) => processPhoto(ctx.update, (messageContext) async {
    //       print('[Chatterbox] on audio, count: ${messageContext.mediaFiles?.length ?? 0}');
    //       _flowManager.handle(messageContext);
    //     }));
  }

  void startPolling() {
    _bot.start();
  }

  void invokeFromWebhook(Map<String, dynamic> updateJson) {
    print('[Chatterbox] Received update from webhook: $updateJson');
    try {
      final update = Update.fromJson(updateJson);
      _bot.handleUpdate(update);
    } catch (error) {
      print('[Chatterbox] invokeFromWebhook failed: ${error.toString()}');
    }
  }

  void startFlowForMessage(Flow flow, Message message) {
    print('[Chatterbox] startFlowForMessage: ${message.text}');
    // TODO: Encode these args, because if stepUri is an argument it's not parsed properly
    final args = parseArgs(message.text);
    final id = message.chat.id;

    final user = message.from;
    _flowManager.handle(
      MessageContext(userId: id, chatId: id, username: user?.username, locale: user?.languageCode),
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
