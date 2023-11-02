import 'package:chatterbox/src/model/media_file.dart';
import 'package:chatterbox/src/model/sticker_model.dart';
import 'package:televerse/telegram.dart';

extension ListPhotoSizeExt on List<PhotoSize> {
  List<MediaFile> toMediaFiles() => map((e) => e.toMediaFile()).toList();
}

extension PhotoSizeExt on PhotoSize {
  MediaFile toMediaFile() => MediaFile(
        type: MediaFileType.photo,
        fileId: fileId,
        fileUniqueId: fileUniqueId,
        width: width,
        height: height,
      );
}

extension VideoExt on Video {
  MediaFile toMediaFile() => MediaFile(
        type: MediaFileType.video,
        fileId: fileId,
        fileUniqueId: fileUniqueId,
        width: width,
        height: height,
      );
}

extension StickerExt on Sticker {
  MediaFile toMediaFile() => StickerModel(
        fileId: fileId,
        fileUniqueId: fileUniqueId,
        width: width,
        height: height,
        fileSize: fileSize,
        isAnimated: isAnimated,
        emoji: emoji,
        setName: setName,
      );
}
