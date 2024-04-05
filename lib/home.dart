import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'dart:developer';
import 'package:gptest1/response_page.dart';

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
        backgroundColor: Color.fromARGB(255, 104, 206, 153),
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
                              n: 1,
                            );
                            // Listen to the stream.
                            List<String?> texts = [];
                            String output = "";
                            chatStream.listen(
                              (streamChatCompletion) {
                                final content = streamChatCompletion
                                    .choices.first.delta.content;
                                // Extract and concatenate the 'text' values
                                String? text = content
                                    ?.map((item) => item?.text ?? "")
                                    .join();
                                texts.add(text);
                              },
                              onDone: () {
                                log("Done");
                                // Join all text items into a single string
                                output = texts.join();
                                log("Output: $output");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResponsePage(output: output)),
                                );
                              },
                            );

                            //Navigator.of(context).pop();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Look up custom recipes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Hello Random'),
                    );
                  },
                );
              },
              child: const Text('Make random recipe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
