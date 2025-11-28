class Blog {
  int id;
  String title;
  String content;
  DateTime publishedAt;
  bool isLikedByMe = false;

  Blog({
    this.id = 0,
    required this.title,
    required this.content,
    required this.publishedAt,
  });


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
