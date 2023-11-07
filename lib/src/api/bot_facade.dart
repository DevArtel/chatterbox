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

  Future<int> sendInvoice(int chatId, InvoiceInfo invoiceInfo);
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
    _verifyButtons(buttons);
    if (editMessageId == null) {
      print("[ChatUtils] replyWithButtons new message");
      return sendMessage(chatId, text, replyMarkup: createButtons(buttons));
    } else {
      print("[ChatUtils] replyWithButtons edit message with id: $editMessageId");
      return editMessageText(chatId, editMessageId, text: text, replyMarkup: createButtons(buttons));
    }
  }

  @override
  Future<int> sendInvoice(int chatId, InvoiceInfo invoiceInfo) async {
    final message = await api.sendInvoice(
      ChatID(chatId),
      title: invoiceInfo.title,
      description: invoiceInfo.description,
      payload: invoiceInfo.payload,
      providerToken: invoiceInfo.providerToken,
      currency: invoiceInfo.currency,
      prices: invoiceInfo.prices,
      messageThreadId: invoiceInfo.messageThreadId,
      maxTipAmount: invoiceInfo.maxTipAmount,
      suggestedTipAmounts: invoiceInfo.suggestedTipAmounts,
      startParameter: invoiceInfo.startParameter,
      providerData: invoiceInfo.providerData,
      photoUrl: invoiceInfo.photoUrl,
      photoSize: invoiceInfo.photoSize,
      photoWidth: invoiceInfo.photoWidth,
      photoHeight: invoiceInfo.photoHeight,
      needName: invoiceInfo.needName,
      needPhoneNumber: invoiceInfo.needPhoneNumber,
      needEmail: invoiceInfo.needEmail,
      needShippingAddress: invoiceInfo.needShippingAddress,
      sendPhoneNumberToProvider: invoiceInfo.sendPhoneNumberToProvider,
      sendEmailToProvider: invoiceInfo.sendEmailToProvider,
      isFlexible: invoiceInfo.isFlexible,
      disableNotification: invoiceInfo.disableNotification,
      protectContent: invoiceInfo.protectContent,
      replyToMessageId: invoiceInfo.replyToMessageId,
      allowSendingWithoutReply: invoiceInfo.allowSendingWithoutReply,
      replyMarkup: invoiceInfo.replyMarkup,
    );
    return message.messageId;
  }
}

void _verifyButtons(List<InlineButton> buttons) {
  for (var element in buttons) {
    if (element.externalUrl?.isNotEmpty != true && element.nextStepUri?.isNotEmpty != true) {
      throw 'Button ${element.title} must have one of the properties externalUrl or nextStepUri';
    }
  }
}
