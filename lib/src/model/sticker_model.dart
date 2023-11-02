import 'package:chatterbox/chatterbox.dart';

class StickerModel extends MediaFile {
  final bool isAnimated;
  final String? emoji;
  final String? setName;

  StickerModel({
    // MediaFile
    required String fileId,
    required String fileUniqueId,
    required int width,
    required int height,
    int? fileSize,

    // StickerModel
    required this.isAnimated,
    this.emoji,
    this.setName,
  }) : super(
          type: MediaFileType.photo,
          fileId: fileId,
          fileUniqueId: fileUniqueId,
          width: width,
          height: height,
          fileSize: fileSize,
        );
}
