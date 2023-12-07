import 'package:chatterbox/src/model/inline_button.dart';
import 'package:televerse/telegram.dart';

String? parseCommand(String? text, List<MessageEntity>? entities) {
  final entity = entities?.first;
  final offset = (entity?.offset ?? 0) + 1;
  final length = entity?.length ?? 0;
  return text?.substring(offset, offset + length - 1);
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

InlineKeyboardMarkup createButtons(List<InlineButton> buttons) {
  return InlineKeyboardMarkup(
    inlineKeyboard: buttons
        .map((button) => [
              _createButton(
                title: button.title,
                callbackData: button.nextStepUri,
                url: button.externalUrl,
              )
            ])
        .toList(),
  );
}

InlineKeyboardButton _createButton({required String title, String? callbackData, String? url}) {
  if (callbackData != null) {
    return InlineKeyboardButton(text: title, callbackData: callbackData);
  } else {
    return InlineKeyboardButton(text: title, url: url!); // TODO: Handle null url
  }
}
