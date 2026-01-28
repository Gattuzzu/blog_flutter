import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        child: Column(
          children: [
            Text("Function not yet implemented."),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
              onPressed: () => {context.pop()},
              child: Text("Last Screen"),
              ),
          ],
        )
      )
    );
  }
}