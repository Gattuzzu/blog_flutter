import 'package:gattus_blog/domain/models/blog.dart';
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

              if(blog.headerImageUrl != null)
                drawImage(blog.headerImageUrl!)
              else
                drawImage('https://picsum.photos/seed/${blog.id}/500'), // Es soll random Bild angezeigt werden

              Text(blog.contentPreview ?? "Kein Bloginhalt vorhanden"),
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

  Widget drawImage(String imageUrl){
    return Column(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress){
            if(loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator()
            );
          },
          errorBuilder: (context, error, stackTrace){
            return const Icon(
              Icons.broken_image_outlined, 
              size: 50, 
              color: Colors.grey
            );
          },
        ),
        SizedBox(height: 5,),
      ],
    );
  }

}
