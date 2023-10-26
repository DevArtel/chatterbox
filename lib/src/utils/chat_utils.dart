import 'package:chatterbox/src/api/bot_facade.dart';
import 'package:chatterbox/src/model/inline_button.dart';
import 'package:televerse/telegram.dart';

String? parseCommand(Message? message) {
  final entity = message?.entities?.first;
  var offset = (entity?.offset ?? 0) + 1;
  var length = entity?.length ?? 0;
  return message?.text?.substring(offset, offset + length - 1);
}

List<String> parseArgs(String? text) {
  if (text != null) {
    final words = text.split(' ');
    if (words.length > 1 && words.first.startsWith('/')) {
      final args = words.sublist(1);
      print('[BOT] Parsed arguments $args');
      return args;
    }
    return words;
  }
  return [];
}

Future<int?> replyWithButtons(
  BotFacade bot,
  int chatId, {
  int? editMessageId,
  required String text,
  required List<InlineButton> buttons,
}) async {
  if (editMessageId == null) {
    print('[ChatUtils] replyWithButtons new message');
    return bot.sendMessage(
      chatId,
      text,
      replyMarkup: createButtons(buttons),
    );
  } else {
    print('[ChatUtils] replyWithButtons edit message with id: $editMessageId');
    return bot.editMessageText(
      chatId,
      editMessageId,
      text: text,
      replyMarkup: createButtons(buttons),
    );
  }
}

InlineKeyboardMarkup createButtons(List<InlineButton> buttons) {
  return InlineKeyboardMarkup(
    inlineKeyboard: [
      buttons
          .map((button) => _createButton(
                title: button.title,
                callbackData: button.nextStepUri,
                url: button.externalUrl,
              ))
          .toList(),
    ],
  );
}

InlineKeyboardButton _createButton({required String title, String? callbackData, String? url}) {
  if (callbackData != null) {
    return InlineKeyboardButton(text: title, callbackData: callbackData);
  } else {
    return InlineKeyboardButton(text: title, url: url!); // TODO: Handle null url
  }
}
