import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/src/utils/chat_utils.dart';
import 'package:chatterbox/src/utils/media_file_converters.dart';
import 'package:televerse/telegram.dart';

typedef UpdateCommandHandler = Future<void> Function(MessageContext messageContext, String command);
typedef UpdateMessageHandler = Future<void> Function(MessageContext messageContext);
typedef UpdateStepHandler = Future<void> Function(MessageContext messageContext, StepUri stepUri);
typedef UpdateMediaFileHandler = Future<void> Function(MessageContext messageContext, String? command);

void processText(Update update, UpdateMessageHandler commandHandler) {
  final message = update.message;
  if (message != null) {
    processTextInternal(message, commandHandler);
  }
}

void processChannelText(Update update, UpdateMessageHandler commandHandler) {
  final message = update.channelPost;
  if (message != null) {
    processChannelTextInternal(message, commandHandler);
  }
}

void processCommand(Update update, UpdateCommandHandler commandHandler) {
  final message = update.message;
  final command = parseCommand(message?.text, message?.entities);
  if (message != null && command != null) {
    processTextInternal(message, (messageContext) => commandHandler(messageContext, command));
  }
}

void processChannelCommand(Update update, UpdateCommandHandler commandHandler) {
  final message = update.channelPost;
  final command = parseCommand(message?.text, message?.entities);
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
    original: message,
    locale: user?.languageCode,
    editMessageId: message.messageId,
    username: user?.username,
    text: message.text,
  ));
}

void processChannelTextInternal(Message message, UpdateMessageHandler commandHandler) {
  final chatId = message.chat.id;
  final user = message.senderChat;
  final userId = user?.id;

  if (userId == null) return;

  commandHandler(MessageContext(
    userId: userId,
    chatId: chatId,
    original: message,
    locale: null,
    editMessageId: message.messageId,
    username: user?.username,
    text: message.text,
  ));
}

void processCallbackQuery(Update update, UpdateStepHandler commandHandler) {
  final callbackQuery = update.callbackQuery;
  if (callbackQuery != null) {
    final message = callbackQuery.message;
    if (message == null || message is! Message) return;

    final chatId = message.chat.id;
    final userId = chatId; // TODO: Test for groups. message.from.id returns id of opponent
    final data = callbackQuery.data;
    final user = callbackQuery.from;

    commandHandler(
      MessageContext(
        userId: userId,
        chatId: chatId,
        original: message,
        locale: user.languageCode,
        editMessageId: message.messageId,
        username: user.username,
      ),
      data!, //todo
    );
  }
}

void processPreCheckoutQuery(Update update, UpdateStepHandler commandHandler) {
  final preCheckoutQuery = update.preCheckoutQuery;
  if (preCheckoutQuery != null) {
    final user = preCheckoutQuery.from;

    final stepUri = preCheckoutQuery.invoicePayload;
    final userId = user.id;

    commandHandler(
      MessageContext(
        userId: userId,
        chatId: userId, //todo check if can be coming from actual chat, not user
        original: null,
        locale: user.languageCode,
        username: user.username,
        preCheckoutInfo: preCheckoutQuery,
      ),
      stepUri,
    );
  }
}

void processSuccessfulPayment(Update update, UpdateMessageHandler commandHandler) {
  final message = update.message;
  final user = message?.from;
  final userId = user?.id;

  final successfulPayment = update.message?.successfulPayment;

  if (successfulPayment == null || userId == null) return;
  final chatId = message?.chat.id ?? userId;

  commandHandler(
    MessageContext(
      userId: userId,
      chatId: chatId,
      original: message,
      locale: user?.languageCode,
      username: user?.username,
      successfulPayment: successfulPayment,
    ),
  );
}

void processPhoto(Update update, UpdateMediaFileHandler commandHandler) {
  _processMediaFile(
    update,
    (Message? message) => message?.photo?.toMediaFiles(),
    commandHandler,
  );
}

void processVideo(Update update, UpdateMediaFileHandler commandHandler) {
  _processMediaFile(
    update,
    (Message? message) {
      final mediaFile = message?.video?.toMediaFile();
      return mediaFile == null ? null : [mediaFile];
    },
    commandHandler,
  );
}

void processSticker(Update update, UpdateMediaFileHandler commandHandler) {
  _processMediaFile(
    update,
    (Message? message) {
      final mediaFile = message?.sticker?.toMediaFile();
      return mediaFile == null ? null : [mediaFile];
    },
    commandHandler,
  );
}

void _processMediaFile(
  Update update,
  List<MediaFile>? Function(Message?) toMediaFiles,
  UpdateMediaFileHandler commandHandler,
) {
  final message = update.message;
  final chatId = message?.chat.id;
  final user = message?.from;
  final userId = user?.id;

  final command = parseCommand(message?.caption, message?.captionEntities);
  final files = toMediaFiles(update.message);
  if (files == null || userId == null) return;

  commandHandler(
    MessageContext(
      userId: userId,
      chatId: chatId ?? userId,
      original: message,
      text: message?.caption,
      editMessageId: message?.messageId,
      locale: user?.languageCode,
      username: user?.username ?? '',
      mediaFiles: files,
    ),
    command,
  );
}
