class Blog {
  int id;
  String title;
  String content;
  DateTime publishedAt;
  bool isLikedByMe;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.isLikedByMe,
  });
}
