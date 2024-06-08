import 'package:flutter/material.dart';

final List<Map<String, String>> favorites = [];

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Recipes'),
        backgroundColor: const Color(0xFF00B48C),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: favorites.map((favorite) {
            String requestText = favorite['request'] ?? 'Request Error';
            //print('Favorite Request: $requestText'); // Debug print statement
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width buttons
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteDetailPage(
                        request: requestText,
                        response: favorite['response'] ?? 'No Response',
                      ),
                    ),
                  );
                },
                child: Text(
                  requestText.isNotEmpty ? requestText : 'No Request',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FavoriteDetailPage extends StatelessWidget {
  final String request;
  final String response;

  const FavoriteDetailPage(
      {super.key, required this.request, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(request),
        backgroundColor: const Color(0xFF00B48C),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          response,
          style: const TextStyle(
            fontFamily: 'Outfit',
            color: Colors.black,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
