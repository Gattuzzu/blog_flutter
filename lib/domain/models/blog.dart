class Blog {
  String id;
  String author;
  String title;
  String? contentPreview;
  String? content;
  DateTime publishedAt;
  DateTime? lastUpdate;
  Object? comments;
  String? headerImageUrl;
  bool isLikedByMe;
  int likes = 0;
  List<String>? userIdsWithLikes;
  bool createdByMe;

  Blog({
    this.id = "0",
    required this.author,
    required this.title,
    this.contentPreview,
    required this.content,
    required this.publishedAt,
    this.lastUpdate,
    this.comments,
    this.headerImageUrl,
    this.userIdsWithLikes,
    this.isLikedByMe = false,
    this.likes = 0,
    this.createdByMe = false,
  }){
    lastUpdate ??= publishedAt;
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        // 1. & 2. Korrekter Key ($id) und korrekter Typ (String)
        'id': int id, 
        'author': String author,
        'title': String title,
        // 3. Datum als String holen, um es später zu parsen
        'createdAt': String createdAt, 
        'updatedAt': String lastUpdate,

        'likes': int likes,
        'likedByMe': bool likedByMe,
        'createdByMe': bool createdByMe,
      } =>
        Blog(
          id: id.toString(),
          author: author,
          title: title,
          contentPreview: json['contentPreview'] as String?,
          content: json['content'] as String?,
          // String in DateTime umwandeln
          publishedAt: DateTime.parse(createdAt), 
          lastUpdate: DateTime.parse(lastUpdate),
          // Optional: Falls du ein Bild hast, das auch null sein kann:
          // headerImageUrl: json['headerImageUrl'] as String?,
          comments: json['comments'] as Object?,
          headerImageUrl: json['headerImageUrl'] as String?,
          userIdsWithLikes: (json['userIdsWithLikes'] as List<dynamic>?)?.cast<String>(),
          isLikedByMe: likedByMe,
          likes: likes,
          createdByMe: createdByMe,
        ),
      _ => throw const FormatException('Failed to convert from json to Blog'),
    };
  }

  Map<String, String> toJson() {
    return {
      "title": title,
      "content": content ?? "",
      // "headerImageUrl": headerImageUrl ?? "",
    };
  }

  /* Validatore */
  static String? titleValidator(String? value){
    if(value == null || value.length < 4){
      return "Enter at least 4 characters";
    } else {
      return null;
    }
  }

  static String? contentValidator(String? value){
    if(value == null || value.length < 10){
      return "Enter at least 10 characters";
    } else {
      return null;
    }
  }
}


/*
{
  "$collectionId": "blogs",
  "$createdAt": "2025-12-01T15:02:27.717+00:00",
  "$databaseId": "blog-db",
  "$id": "692dae03aeefac9e0f82",
  "$permissions": [],
  "$sequence": 352,
  "$updatedAt": "2025-12-05T14:01:30.232+00:00",
  "comments": null,
  "content": "Super! Best Blog App ever never. =S\n\n💪",
  "headerImageUrl": null,
  "title": "Neuer Blog ist toll!!",
  "userIdsWithLikes": [
      "my_user_id"
  ]
},
*/