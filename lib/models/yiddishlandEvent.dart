
class YiddishlandEvent {
  String id;
  String title;
  String description;
  String src;
  String imageSrc;

  YiddishlandEvent({
    required this.id,
    required this.title,
    this.description = "",
    required this.src,
    required this.imageSrc,
  });
}