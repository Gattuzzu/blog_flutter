import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/screens/blog_detail/blog_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogDetailScreen extends StatelessWidget{
  final int blogId;

  const BlogDetailScreen({super.key, required this.blogId});
  
  @override
  Widget build(BuildContext context) {
    final blogDetailViewModel = context.watch<BlogDetailViewModel>();
    return Stack(
      children: [
        if(blogDetailViewModel.isLoading)
          Center(child: CircularProgressIndicator(),),
        if(!blogDetailViewModel.isLoading && blogDetailViewModel.blog == null)
          Center(child: Text('Error while loading the Blog $blogId'),)
        else if(blogDetailViewModel.blog != null)
          BlogCard(
            blog: blogDetailViewModel.blog!, 
            dateFormatter: DateFormat('dd.MM.yyyy'), 
            onLikeToggle: () => blogDetailViewModel.toggleLike(blogId)
          ),
      ],
    );
  }
}