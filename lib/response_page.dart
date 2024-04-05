import 'package:flutter/material.dart';

class ResponsePage extends StatelessWidget {
  final String output;

  ResponsePage({required this.output});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Output'),
      ),
      backgroundColor: Color.fromARGB(255, 104, 206, 153),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(output)],
        ),
      ),
    );
  }
}
