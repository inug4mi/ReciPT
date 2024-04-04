import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'dart:developer';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //final openai = OpenAI(apiKey: 'YOUR_API_KEY_HERE'); // Replace with your OpenAI API key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ReciPT')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String inputValue = '';
                    return AlertDialog(
                      title: Text('Enter Text'),
                      content: TextField(
                        onChanged: (value) {
                          inputValue = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your text here',
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            final userMessage =
                                OpenAIChatCompletionChoiceMessageModel(
                              content: [
                                OpenAIChatCompletionChoiceMessageContentItemModel
                                    .text(
                                  inputValue,
                                ),
                              ],
                              role: OpenAIChatMessageRole.user,
                            );

// The request to be sent.
                            final chatStream =
                                OpenAI.instance.chat.createStream(
                              model: "gpt-3.5-turbo",
                              messages: [
                                userMessage,
                              ],
                              seed: 423,
                              n: 2,
                            );

// Listen to the stream.
                            chatStream.listen(
                              (streamChatCompletion) {
                                final content = streamChatCompletion
                                    .choices.first.delta.content;
                                log('data: $content');
                              },
                              onDone: () {
                                log("Done");
                              },
                            );

                            Navigator.of(context).pop();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Open Popup'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hello Random'),
                    );
                  },
                );
              },
              child: Text('Random'),
            ),
          ],
        ),
      ),
    );
  }
}
