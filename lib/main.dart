import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:gptest1/env/env.dart';
import 'package:gptest1/home.dart';

//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
void main() {
  OpenAI.apiKey = Env.key1;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(title: 'Flutter Demo Home Page'),
    );
  }
}
