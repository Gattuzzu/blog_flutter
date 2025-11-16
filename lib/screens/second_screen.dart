import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String title;
  const SecondScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
          onPressed: () => {onPressed(context)},
          child: Text("Last Screen"),
          )
      )
    );
  }
  
  onPressed(context) => {Navigator.pop(context)};
}