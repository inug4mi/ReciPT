import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:gptest1/env/env.dart';
import 'package:gptest1/pages/home_page.dart';

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
      title: 'ReciPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(title: 'ReciPT'),
    );
  }
}
