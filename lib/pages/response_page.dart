import 'package:flutter/material.dart';
import 'package:gptest1/pages/favorites_page.dart';

class ResponsePage extends StatelessWidget {
  final String output;
  final String request; // Add request to store the request text

  const ResponsePage({super.key, required this.output, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response'),
        backgroundColor: const Color(0xFF00B48C),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // Save the response to favorites
              favorites.add({
                'request': request,
                'response': output,
              });
              //print('Added to favorites: $request'); // Debug print statement
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites')),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                output,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.black,
                  fontSize: 20,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
