class StickerModel {
  final String fileId;
  final String fileUniqueId;
  final bool isAnimated;
  final String? emoji;
  final String? setName;

  StickerModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.isAnimated,
    this.emoji,
    this.setName,
  });
}
