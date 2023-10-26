import 'package:chatterbox/src/model/sticker_model.dart';

class MessageContext {
  final int userId;
  final int chatId;
  final int? editMessageId;
  final String? username;
  final StickerModel? sticker;

  // final MediaFile? mediaFile; //todo

  MessageContext({
    required this.userId,
    required this.chatId,
    this.editMessageId,
    this.username,
    this.sticker,
    // this.mediaFile,
  });
}
