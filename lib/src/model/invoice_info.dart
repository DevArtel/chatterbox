import 'package:televerse/telegram.dart';

/// Documentation for fields of the class can be found [here](https://core.telegram.org/bots/api#sendinvoice)
/// Except for payload filed which is used to store next step uri and passed through [ReactionInvoice.preCheckoutStepUri]
class InvoiceInfo {
  InvoiceInfo({
    required this.title,
    required this.description,
    required this.providerToken,
    required this.currency,
    required this.prices,
    this.messageThreadId,
    this.maxTipAmount = 0,
    this.suggestedTipAmounts,
    this.startParameter,
    this.providerData,
    this.photoUrl,
    this.photoSize,
    this.photoWidth,
    this.photoHeight,
    this.needName,
    this.needPhoneNumber,
    this.needEmail,
    this.needShippingAddress,
    this.sendPhoneNumberToProvider,
    this.sendEmailToProvider,
    this.isFlexible,
    this.disableNotification,
    this.protectContent,
    this.replyToMessageId,
    this.allowSendingWithoutReply,
    this.replyMarkup,
  });

  String title;
  String description;
  String providerToken;
  String currency;
  List<LabeledPrice> prices;
  int? messageThreadId;
  int maxTipAmount;
  List<int>? suggestedTipAmounts;
  String? startParameter;
  dynamic providerData;
  String? photoUrl;
  int? photoSize;
  int? photoWidth;
  int? photoHeight;
  bool? needName;
  bool? needPhoneNumber;
  bool? needEmail;
  bool? needShippingAddress;
  bool? sendPhoneNumberToProvider;
  bool? sendEmailToProvider;
  bool? isFlexible;
  bool? disableNotification;
  bool? protectContent;
  int? replyToMessageId;
  bool? allowSendingWithoutReply;
  InlineKeyboardMarkup? replyMarkup;
}
