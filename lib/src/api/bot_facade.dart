import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/src/utils/chat_utils.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

typedef JsonData = Map<String, dynamic>;

abstract class BotFacade {
  Future<int> sendMessage(int chatId, String text, {required InlineKeyboardMarkup replyMarkup});

  Future<int> editMessageText(int chatId, int editMessageId,
      {required String text, required InlineKeyboardMarkup replyMarkup});

  Future<int> replyWithButtons(int chatId, int? editMessageId, String text, List<InlineButton> buttons);

  Future<int> sendInvoice(fromId, SuccessfulPayment paymentInvoiceInfo);
}

class BotFacadeImpl extends BotFacade {
  BotFacadeImpl(this.api);

  RawAPI api;

  @override
  Future<int> sendMessage(int chatId, String text, {required InlineKeyboardMarkup replyMarkup}) async {
    final message = await api.sendMessage(ChatID(chatId), text, replyMarkup: replyMarkup);
    return message.messageId;
  }

  @override
  Future<int> editMessageText(int chatId, int editMessageId,
      {required String text, required InlineKeyboardMarkup replyMarkup}) async {
    final message = await api.editMessageText(ChatID(chatId), editMessageId, text, replyMarkup: replyMarkup);
    return message.messageId;
  }

  @override
  Future<int> replyWithButtons(int chatId, int? editMessageId, String text, List<InlineButton> buttons) async {
    if (editMessageId == null) {
      print("[ChatUtils] replyWithButtons new message");
      return sendMessage(chatId, text, replyMarkup: createButtons(buttons));
    } else {
      print("[ChatUtils] replyWithButtons edit message with id: $editMessageId");
      return editMessageText(chatId, editMessageId, text: text, replyMarkup: createButtons(buttons));
    }
  }

  @override
  Future<int> sendInvoice(fromId, SuccessfulPayment paymentInvoiceInfo) {
    throw 'Not implemented';
  }
}
