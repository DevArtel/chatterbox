import 'package:chatterbox/src/model/sticker_model.dart';

class MessageContext {
  final int userId;
  final int chatId;
  final String? text;
  final int? editMessageId;
  final String? username;
  final StickerModel? sticker;

  // final MediaFile? mediaFile; //todo

  MessageContext({
    required this.userId,
    required this.chatId,
    this.text,
    this.editMessageId,
    this.username,
    this.sticker,
    // this.mediaFile,
  });
}
