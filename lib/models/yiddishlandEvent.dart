
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

  factory YiddishlandEvent.fromMap(Map<String, dynamic> data, String documentId) {
    return YiddishlandEvent(
      id: documentId,
      title: data['title'] as String,
      description: data['description'] as String,
      src: data['src'] as String,
      imageSrc: data['imageSrc'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'src': src,
      'imageSrc': imageSrc,
    };
  }
}