import 'package:blog_beispiel/screens/blog_detail/blog_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogDetailScreen extends StatelessWidget{
  final String blogId;

  const BlogDetailScreen({super.key, required this.blogId});
  
  @override
  Widget build(BuildContext context) {
    final blogDetailViewModel = context.watch<BlogDetailViewModel>();
    return Stack(
      children: [
        if(blogDetailViewModel.pageState == BlogDetailViewPageState.done && blogDetailViewModel.blog == null)
          Center(child: Text('Error while loading the Blog $blogId'),)
        else if(blogDetailViewModel.blog != null)
          _buildBlogDetail(context, blogDetailViewModel),
        if(blogDetailViewModel.pageState == BlogDetailViewPageState.editing || blogDetailViewModel.pageState == BlogDetailViewPageState.updating)
          _buildEditor(context, blogDetailViewModel),
        if(blogDetailViewModel.pageState == BlogDetailViewPageState.loading || 
           blogDetailViewModel.pageState == BlogDetailViewPageState.updating ||
           blogDetailViewModel.pageState == BlogDetailViewPageState.deleting )
          Center(child: CircularProgressIndicator(),),
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
          _buildImage(context, viewModel),
          SizedBox(
            height: 10,
          ),
          _buildContent(/* context, */ viewModel),
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
          onPressed: () => {viewModel.setPageStateToEdit(BlogField.title)},
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context, BlogDetailViewModel viewModel){
    if (viewModel.blog?.headerImageUrl != null) {
      return Column(
        children: [
          Image.network(
            viewModel.blog!.headerImageUrl!,
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
          const SizedBox(height: 5),
        ],
      );
    }
    return const SizedBox.shrink();
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
          onPressed: () => {viewModel.setPageStateToEdit(BlogField.content)},
        ),
      ],
    );
  }

  Widget _buildDateAndLike(BuildContext context, BlogDetailViewModel viewModel){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd.MM.yyyy').format(viewModel.blog!.publishedAt)),
            IconButton(
              icon: Icon(viewModel.blog!.isLikedByMe ? Icons.favorite : Icons.heart_broken),
              onPressed: () => viewModel.toggleLike(viewModel.blog!.id),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => viewModel.deleteBlog(viewModel.blog!.id, context),
        ), 
      ],
    );
  }

  Widget _buildEditor(BuildContext context, BlogDetailViewModel viewModel){
   return Stack(
      children: [
        _buildGreyOverlay(context),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.field!.label,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: viewModel.formKey,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: ListView(
                        shrinkWrap: true, // Berechnet die Höhe der ListView anhand des benötigten Platzes von den kindern.
                        children: [
                          _buildInput(viewModel),
                          SizedBox(height: 10,),
                          _buildButtons(context, viewModel),
                        ]
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGreyOverlay(BuildContext context){
    return GestureDetector(
      onTap: () => {}, // mach nichts, aber alle Klicks abfangen. Ansonnsten werden sie an das nächste Widget weitergeleitet. 
      behavior: HitTestBehavior.opaque, // Dies ist wichtig, dass die Events nicht weitergeleitet werden
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.secondary.withValues(
          alpha: 0.5,
        ),
      ),
    );
  }

  Widget _buildInput(BlogDetailViewModel viewModel){
    return switch(viewModel.field!) {
      BlogField.title => _buildEditTitle(viewModel),
      BlogField.content => _buildEditContent(viewModel),
    };
  }

  Widget _buildEditTitle(BlogDetailViewModel viewModel){
    return TextFormField(
      initialValue: viewModel.blog!.title,
      enabled: viewModel.pageState == BlogDetailViewPageState.editing,
      decoration: InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: viewModel.titleValidator,
      onSaved: viewModel.setTitle,
    );
  }

  Widget _buildEditContent(BlogDetailViewModel viewModel){
    return TextFormField(
      initialValue: viewModel.blog!.content,
      enabled: viewModel.pageState == BlogDetailViewPageState.editing,
      decoration: InputDecoration(
        labelText: "Content",
        border: OutlineInputBorder(),
      ),
      minLines: 5,
      maxLines: 20,
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: viewModel.contentValidator,
      onSaved: viewModel.setContent,
    );
  }

  Widget _buildButtons(BuildContext context, BlogDetailViewModel viewModel){
    Color backgroundColor = viewModel.pageState == BlogDetailViewPageState.editing ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.inversePrimary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: backgroundColor,
          onPressed: () => viewModel.onUpdate(blogId, context),
          child: Text("Update"),
        ),
        SizedBox(width: 10,),
        FloatingActionButton(
          backgroundColor: backgroundColor,
          onPressed: () => {viewModel.setPageStateToDone()}, // Cancel
          child: Text("Cancel")
        ),
      ],
    );
  }

}