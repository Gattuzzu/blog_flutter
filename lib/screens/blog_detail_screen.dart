import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogDetailScreen extends StatelessWidget{
  final blogRepository = BlogRepository.instance;
  final Blog blog;

  BlogDetailScreen({super.key, required this.blog});
  
  @override
  Widget build(Object context) {
    return BlogCard(
      blog: blog, 
      dateFormatter: DateFormat('dd.MM.yyyy'), 
      onLikeToggle: () => onToggleLikeStatus(blog)
    );
  }

  void onToggleLikeStatus(Blog blog){
    blog.isLikedByMe = !blog.isLikedByMe;
    blogRepository.toggleLikeInfo(blog.id);
  }
  
}