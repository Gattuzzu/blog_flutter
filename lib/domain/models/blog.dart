class Blog {
  String id;
  String title;
  String content;
  DateTime publishedAt;
  DateTime? lastUpdate;
  Object? comments;
  String? headerImageUrl;
  bool isLikedByMe = false;
  List<String>? userIdsWithLikes;

  Blog({
    this.id = "0",
    required this.title,
    required this.content,
    required this.publishedAt,
    this.lastUpdate,
    this.comments,
    this.headerImageUrl,
    this.userIdsWithLikes,
  }){
    lastUpdate ??= publishedAt;
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        // 1. & 2. Korrekter Key ($id) und korrekter Typ (String)
        r'$id': String id, 
        'title': String title,
        'content': String content,
        // 3. Datum als String holen, um es später zu parsen
        r'$createdAt': String createdAt, 
        r'$updatedAt': String lastUpdate,
        'comments': Object? comments,
        'headerImageUrl': String? headerImageUrl,
        'userIdsWithLikes': List<dynamic> userIdsWithLikes,
      } =>
        Blog(
          id: id,
          title: title,
          content: content,
          // String in DateTime umwandeln
          publishedAt: DateTime.parse(createdAt), 
          lastUpdate: DateTime.parse(lastUpdate),
          // Optional: Falls du ein Bild hast, das auch null sein kann:
          // headerImageUrl: json['headerImageUrl'] as String?,
          comments: comments,
          headerImageUrl: headerImageUrl,
          userIdsWithLikes: userIdsWithLikes.cast<String>(),
        ),
      _ => throw const FormatException('Failed to convert from json to Blog'),
    };
  }

  Map<String, String> toJson() {
    return {
      "title": title,
      "content": content,
      r'$createdAt': publishedAt.toIso8601String(),
      r'$updatedAt': DateTime.now().toIso8601String(), // wenn das Objekt in Json geparst wird, gehe ich davon aus, dass es geänder wird.
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