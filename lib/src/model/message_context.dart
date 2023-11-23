import 'package:chatterbox/src/model/media_file.dart';
import 'package:chatterbox/src/model/sticker_model.dart';
import 'package:televerse/telegram.dart';

class MessageContext {
  final int userId;
  final int chatId;
  final String? username;
  final String? locale;
  final String? text;

  /// Id of the message to which user is replying to
  /// Common usecase is to update that message by removing buttons
  final int? editMessageId;
  final StickerModel? sticker; //todo should remove and use mediaFiles instead?
  final List<MediaFile>? mediaFiles;
  final PreCheckoutQuery? preCheckoutInfo; //todo should not use model from televerse?
  final SuccessfulPayment? successfulPayment;

  MessageContext({
    required this.userId,
    required this.chatId,
    this.username,
    this.locale,
    this.text,
    this.editMessageId,
    this.sticker,
    this.mediaFiles,
    this.preCheckoutInfo,
    this.successfulPayment,
  });
}
