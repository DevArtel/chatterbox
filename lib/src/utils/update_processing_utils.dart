import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/model/message_context.dart';
import 'package:chatterbox/src/utils/chat_utils.dart';
import 'package:televerse/telegram.dart';

typedef UpdateCommandHandler = Future<void> Function(MessageContext messageContext, String command);
typedef UpdateMessageHandler = Future<void> Function(MessageContext messageContext);
typedef UpdateStepHandler = Future<void> Function(MessageContext messageContext, StepUri stepUri);

void processText(Update update, UpdateMessageHandler commandHandler) {
  final message = update.message;
  if (message != null) {
    processTextInternal(message, commandHandler);
  }
}

void processCommand(Update update, UpdateCommandHandler commandHandler) {
  final message = update.message;
  final command = parseCommand(message);
  if (message != null && command != null) {
    processTextInternal(message, (messageContext) => commandHandler(messageContext, command));
  }
}

void processTextInternal(Message message, UpdateMessageHandler commandHandler) {
  final chatId = message.chat.id;
  final user = message.from;
  final userId = user?.id;

  if (userId == null) return;

  commandHandler(MessageContext(
    userId: userId,
    chatId: chatId,
    editMessageId: message.messageId,
    username: user?.username,
  ));
}

void processCallbackQuery(Update update, UpdateStepHandler commandHandler) {
  final callbackQuery = update.callbackQuery;
  if (callbackQuery != null) {
    final message = callbackQuery.message;
    if (message == null) return;

    final chatId = message.chat.id;
    final userId = chatId; // TODO: Test for groups. message.from.id returns id of opponent
    final data = callbackQuery.data;

    commandHandler(
      MessageContext(
        userId: userId,
        chatId: chatId,
        editMessageId: message.messageId,
        username: message.from?.username,
      ),
      data!, //todo
    );
  }
}

void processPreCheckoutQuery(Update update, UpdateStepHandler commandHandler) {
  final preCheckoutQuery = update.preCheckoutQuery;
  if (preCheckoutQuery != null) {
    final user = preCheckoutQuery.from;
    print('[ACCOUNT_MANAGER_BOT] received preCheckouQuery from user ${user.id}');

    final stepUri = preCheckoutQuery.invoicePayload;
    final userId = user.id;
    // commandHandler(MessageContext(userId, userId, username: user.username), stepUri);
    commandHandler(
      MessageContext(
        userId: userId,
        chatId: userId,
        // editMessageId: message.messageId,
        username: user.username,
      ),
      stepUri,
    );
  }
}

// void processMediaFile(Message message, MediaFile media, CommandMessageHandler commandHandler) {
//   final chatId = message.chat.id;
//   final user = message.from;
//   final userId = user?.id;
//
//   if (userId == null) return;
//
//   commandHandler(MessageContext(
//     userId: userId,
//     chatId: chatId,
//     username: user.username,
//     // mediaFile: media, //todo
//   ));
// }

// ... (other classes and functions)
