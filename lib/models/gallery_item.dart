enum GalleryItemType {
  image,
  video,
}

class GalleryItem {
  final String id;
  final String path;
  final GalleryItemType type;
  final DateTime dateAdded;
  final String? thumbnail;

  GalleryItem({
    required this.id,
    required this.path,
    required this.type,
    required this.dateAdded,
    this.thumbnail,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}