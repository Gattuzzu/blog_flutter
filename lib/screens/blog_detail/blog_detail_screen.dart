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
          _buildBlogDetail(context, blogDetailViewModel),
      ],
    );
  }

  Widget _buildBlogDetail(BuildContext context, BlogDetailViewModel viewModel){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, viewModel),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          _buildContent(viewModel),
          SizedBox(
            height: 10,
          ),
          _buildDateAndLike(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, BlogDetailViewModel viewModel){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text( 
            viewModel.blog!.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildContent(/* BuildContext context, */ BlogDetailViewModel viewModel){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(viewModel.blog!.content)
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildDateAndLike(BuildContext context, BlogDetailViewModel viewModel){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(DateFormat('dd.MM.yyyy').format(viewModel.blog!.publishedAt)),
        IconButton(
          icon: Icon(viewModel.blog!.isLikedByMe ? Icons.favorite : Icons.heart_broken),
          onPressed: () => viewModel.toggleLike(viewModel.blog!.id),
        ),
      ],
    );
  }

}