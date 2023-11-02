enum MediaFileType { sticker, photo, video, animation }

class MediaFile {
  MediaFile({
    required this.type,
    required this.fileId,
    required this.fileUniqueId,
    required this.width,
    required this.height,
    this.fileSize,
  });

  final MediaFileType type;
  final String fileId;
  final String fileUniqueId;
  final int width;
  final int height;
  final int? fileSize;
}
