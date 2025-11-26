
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog>{
  final formKey = GlobalKey<FormState>();
  final blogRepository = BlogRepository.instance;

  String _title = "";
  String _content = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: ListView(
            children: [
              buildTitle(),
              SizedBox(height: 10),
              buildContent(),
              SizedBox(height: 10),
              buildSubmitButton(context),
            ],
          )
        )
      ),
    );
  }

  Widget buildTitle(){
    return TextFormField(
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

  Widget buildContent(){
    return TextFormField(
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

  Widget buildSubmitButton(BuildContext context){
    return FloatingActionButton(
      child: Text("Submit"),
      onPressed: () {
        if (formKey.currentState != null)
        {
          final isValid = formKey.currentState!.validate();
          if (isValid){
            FocusScope.of(context).unfocus();
            formKey.currentState!.save();
            blogRepository.addBlogPost(Blog(
              title: _title,
              content: _content,
              publishedAt: DateTime.now(),
            ));
            context.push(AppRoutes.blogOverview);
          }
        }
      },
    );
  }

}