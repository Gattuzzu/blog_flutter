import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/blog_detail/blog_detail_state.dart';
import 'package:blog_beispiel/screens/blog_detail/blog_detail_view_model.dart';
import 'package:blog_beispiel/services/exceptions/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogDetailScreen extends StatelessWidget{
  final String blogId;

  const BlogDetailScreen({super.key, required this.blogId});
  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BlogDetailViewModel>();
    return Stack(
      children: [
        // Der erst Switch Case baut den eigentlichen Inhalt der Webseite an.
        if (viewModel.state is BlogDetailInitial)
          const Text('State Init')

        else if (viewModel.state case BlogDetailError(message: var msg))
          Center(child: Text(msg))

        else if (viewModel.state is BlogDetailAtLeastOnceLoaded)
          _buildBlogDetail(context, viewModel),

        if (viewModel.state case BlogDetailEditing() || BlogDetailUpdating())
          _buildEditor(context, viewModel),

        if (viewModel.state case BlogDetailLoading() || BlogDetailUpdating() || BlogDetailDeleting())
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildBlogDetail(BuildContext context, BlogDetailViewModel viewModel){
    if (viewModel.state case BlogDetailAtLeastOnceLoaded actState) {
      Blog blog;
      blog = actState.blog;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, viewModel, blog),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 2,
            ),
            _buildImage(context, viewModel, blog),
            SizedBox(
              height: 10,
            ),
            _buildContent(/* context, */ viewModel, blog),
            SizedBox(
              height: 10,
            ),
            _buildDateAndLike(context, viewModel, blog),
          ],
        ),
      );
    } else{
      return Text(errorDuringDevelopment);
    }
  }

  Widget _buildTitle(BuildContext context, BlogDetailViewModel viewModel, Blog blog){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text( 
            blog.title,
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

  Widget _buildImage(BuildContext context, BlogDetailViewModel viewModel, Blog blog){
    if (blog.headerImageUrl != null) {
      return Column(
        children: [
          Image.network(
            blog.headerImageUrl!,
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

  Widget _buildContent(/* BuildContext context, */ BlogDetailViewModel viewModel, Blog blog){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(blog.content)
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => {viewModel.setPageStateToEdit(BlogField.content)},
        ),
      ],
    );
  }

  Widget _buildDateAndLike(BuildContext context, BlogDetailViewModel viewModel, Blog blog){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd.MM.yyyy').format(blog.publishedAt)),
            IconButton(
              icon: Icon(blog.isLikedByMe ? Icons.favorite : Icons.heart_broken),
              onPressed: () => viewModel.toggleLike(blog.id),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => viewModel.deleteBlog(blog.id, context),
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
    if (viewModel.state case BlogDetailAtLeastOnceLoaded actState) {
      Blog blog;
      blog = actState.blog;
      return switch(viewModel.field!) {
        BlogField.title => _buildEditField(  viewModel, true,  blog.title),
        BlogField.content => _buildEditField(viewModel, false, blog.content),
      };
    } else{
      return Text(errorDuringDevelopment);
    }
  }

  // wenn isTitle gesetzt ist, dann ist das Widget für title konfiguriert
  // wenn isTitle ist nicht gesetzt, dann ist das Widget für content konfiguriert
  Widget _buildEditField(BlogDetailViewModel viewModel, bool isTitle, String value){
    return TextFormField(
      initialValue: value,
      enabled: viewModel.state is BlogDetailEditing,
      decoration: InputDecoration(
        labelText: isTitle ? "Title" : "Content",
        border: OutlineInputBorder(),
      ),
      // autovalidateMode: AutovalidateMode.onUnfocus,
      minLines:  isTitle ? null : 5,
      maxLines:  isTitle ? 1 : 20,
      validator: isTitle ? viewModel.titleValidator : viewModel.contentValidator,
      onSaved:   isTitle ? viewModel.setTitle       : viewModel.setContent,
    );
  }

  Widget _buildButtons(BuildContext context, BlogDetailViewModel viewModel){
    Color backgroundColor = viewModel.state is BlogDetailEditing ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.inversePrimary;
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