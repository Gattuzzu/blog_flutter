import 'package:blog_beispiel/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog, required this.dateFormatter, required this.onLikeToggle, this.onTap});

  final DateFormat dateFormatter;
  final Blog blog;
  final VoidCallback onLikeToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(blog.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(blog.content),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateFormatter.format(blog.publishedAt)),
                  IconButton(
                    icon: Icon(blog.isLikedByMe ? Icons.favorite : Icons.heart_broken),
                    onPressed: onLikeToggle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
