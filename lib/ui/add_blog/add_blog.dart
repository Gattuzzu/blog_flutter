import 'package:blog_beispiel/ui/add_blog/add_blog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBlog extends StatelessWidget{
  
  const AddBlog({super.key});

  @override
  Widget build(BuildContext context) {
    final addBlogViewModel = context.watch<AddBlogViewModel>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Stack(
          children: [
            Form(
              key: addBlogViewModel.formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: ListView(
                children: [
                  buildTitle(addBlogViewModel),
                  SizedBox(height: 10),
                  buildContent(addBlogViewModel),
                  SizedBox(height: 10),
                  buildSubmitButton(context, addBlogViewModel),
                ],
              )
            ),
            if(addBlogViewModel.pageState == AddBlogPageState.loading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if(addBlogViewModel.pageState == AddBlogPageState.done)
              Center(
                child: Text("Blog created!"),  
              )
          ],
        ) 
      ),
    );
  }

  Widget buildTitle(AddBlogViewModel addBlogViewModel){
    return TextFormField(
      enabled: addBlogViewModel.pageState == AddBlogPageState.editing,
      decoration: InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: addBlogViewModel.titleValidator,
      onSaved: addBlogViewModel.setTitle,
    );
  }

  Widget buildContent(AddBlogViewModel addBlogViewModel){
    return TextFormField(
      enabled: addBlogViewModel.pageState == AddBlogPageState.editing,
      decoration: InputDecoration(
        labelText: "Content",
        border: OutlineInputBorder(),
      ),
      minLines: 5,
      maxLines: 20,
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: addBlogViewModel.contentValidator,
      onSaved: addBlogViewModel.setContent,
    );
  }

  Widget buildSubmitButton(BuildContext context, AddBlogViewModel addBlogViewModel) {
    return FloatingActionButton(
      backgroundColor: addBlogViewModel.pageState == AddBlogPageState.editing ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.inversePrimary,
      onPressed: () => addBlogViewModel.onSave(context),
      child: Text("Submit"),
    );
  }

}