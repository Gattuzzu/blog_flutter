
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/add_blog/add_blog_view_model.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog>{
  final formKey = GlobalKey<FormState>();

  String _title = "";
  String _content = "";

  @override
  Widget build(BuildContext context) {
    final addBlogViewModel = context.watch<AddBlogViewModel>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Stack(
          children: [
            Form(
              key: formKey,
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
            if(addBlogViewModel.isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ) 
      ),
    );
  }

  Widget buildTitle(AddBlogViewModel addBlogViewModel){
    return TextFormField(
      enabled: !addBlogViewModel.isLoading,
      decoration: InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value){
        if(value == null || value.length < 4){
          return "Enter at least 4 characters";
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => _title = value!),
    );
  }

  Widget buildContent(AddBlogViewModel addBlogViewModel){
    return TextFormField(
      enabled: !addBlogViewModel.isLoading,
      decoration: InputDecoration(
        labelText: "Content",
        border: OutlineInputBorder(),
      ),
      minLines: 5,
      maxLines: 20,
      // autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        if(value == null || value.length < 10){
          return "Enter at least 10 characters";
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => _content = value!),
    );
  }

  Widget buildSubmitButton(BuildContext context, AddBlogViewModel addBlogViewModel) {
    return FloatingActionButton(
      backgroundColor: addBlogViewModel.isLoading ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primaryContainer,
      onPressed: addBlogViewModel.isLoading ? null : () async {
        if (formKey.currentState != null)
        {
          final isValid = formKey.currentState!.validate();
          if (isValid){
            FocusScope.of(context).unfocus();
            formKey.currentState!.save();
            await addBlogViewModel.addBlog(Blog(
              title: _title,
              content: _content,
              publishedAt: DateTime.now(),
            ), context);

            if(!context.mounted) return; // Bevor man eine weiterleitung machen kann, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
          
            context.push(AppRoutes.blogOverview);
          }
        }
      },
      child: Text("Submit"),
    );
  }

}