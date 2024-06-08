import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:gptest1/pages/favorites_page.dart';
import 'package:gptest1/env/food.dart';
import 'package:gptest1/pages/response_page.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedFocus = 'Dessert';
  List<String> selectedIngredients = ['Cream Cheese', 'Honey'];
  String inputValue = '';

  void _showMultiSelectDialog() async {
    final List<String> items = ingredientsOptions[selectedFocus]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initiallySelected: selectedIngredients,
          onSelectionChanged: (List<String> selected) {
            setState(() {
              selectedIngredients = selected;
            });
          },
        );
      },
    );
  }

  void _submit(String selectedFocus, List<String> selectedIngredients,
      BuildContext context) async {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "Can you suggest me $selectedFocus food recipes made of these ingredients: ${selectedIngredients.join(', ')} and can you show me the instructions for making it please.")
      ],
      role: OpenAIChatMessageRole.user,
    );

    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [
        userMessage,
      ],
      seed: 423,
      n: 1,
    );

    List<String?> texts = [];
    String output = "";
    chatStream.listen(
      (streamChatCompletion) {
        final content = streamChatCompletion.choices.first.delta.content;
        String? text = content?.map((item) => item?.text ?? "").join();
        texts.add(text);
      },
      onDone: () {
        output = texts.join();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResponsePage(
                    output: output,
                    request: "$selectedFocus ${selectedIngredients.join(", ")}",
                  )),
        );
      },
    );
  }

  void _getRandom() {
    final random = Random();
    final List<String> keys = ingredientsOptions.keys.toList();
    final String randomKey = keys[random.nextInt(keys.length)];
    final List<String> ingredients = ingredientsOptions[randomKey]!;
    int numIngredients = random.nextInt(ingredients.length) + 1;
    List<String> selectedIngredientsSubset = ingredients..shuffle(random);
    selectedIngredientsSubset =
        selectedIngredientsSubset.take(numIngredients).toList();

    setState(() {
      selectedFocus = randomKey;
      selectedIngredients = selectedIngredientsSubset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B48C),
        automaticallyImplyLeading: false,
        //leading: IconButton(
        //  icon: Image.asset(
        //      "/assets/images/logo.png"), //assets/images/my_icon.png', // Replace Icons.menu with the desired icon
        //  onPressed: () {
        //    // Add your onPressed logic here
        //  },
        //),
        title: const Text(
          'ReciPT',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 25, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'I would love a',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontFamily: 'Outfit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "$selectedFocus recipe",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 123, 0),
                              fontFamily: 'Outfit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'made of...',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontFamily: 'Outfit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            selectedIngredients.join(', '),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 123, 0),
                              fontFamily: 'Readex Pro',
                            ),
                            textAlign: TextAlign.center,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedFocus,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFocus = newValue!;
                          selectedIngredients = [];
                        });
                      },
                      hint: const Text("Please select food type..."),
                      items: ingredientsOptions.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      style: const TextStyle(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 15,
                      ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showMultiSelectDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color(0xFF00B48C),
                        elevation: 3,
                        textStyle: const TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Select Ingredients'),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submit(selectedFocus, selectedIngredients, this.context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF00B48C),
                elevation: 3,
                textStyle: const TextStyle(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0,
                ),
                //padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Look out for this recipe!'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _getRandom();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF00B48C),
                elevation: 3,
                textStyle: const TextStyle(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0,
                ),
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Feeling lucky!'),
            ),
            const SizedBox(height: 15),
            Container(
              //height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildIconButton(
                          context,
                          Icons.star,
                          'Favorite Recipes',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritesPage(),
                              ),
                            );
                          },
                        ),
                        buildIconButton(
                          context,
                          Icons.settings,
                          'Settings',
                          () {
                            // Add onPressed action for Settings button
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initiallySelected;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initiallySelected,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initiallySelected);
  }

  void _onItemCheckedChange(String item, bool checked) {
    setState(() {
      if (checked) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
      widget.onSelectionChanged(selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              value: selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? checked) {
                _onItemCheckedChange(item, checked!);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

Widget buildIconButton(
    BuildContext context, IconData icon, String title, Function()? onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(height: 2),
        ],
      ),
    ),
  );
}
