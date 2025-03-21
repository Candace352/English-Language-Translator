// Imports for all the necessary libraries to be used in the application.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart'; // Import the TTS package

void main() {
  runApp(TranslatorApp());
}

class TranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English to Language Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', 
      ),
      home: TranslationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  bool _isLoading = false;
  String _selectedLanguage = 'es'; // The default language that i am starting with is Spanish
  final FlutterTts flutterTts = FlutterTts(); // Initializing the TTS

  // This is the list of the supported languages that i chose. Added African languages because why not
  final Map<String, String> _languages = {
    'es': 'Spanish',
    'fr': 'French',
    'sn': 'Shona',
    'nr': 'Ndebele',
    'ee': 'Ewe',
  };

  Future<void> _translateText() async {
    if (_textController.text.isEmpty) {
      setState(() {
        //Default instruction to guide the person in what to do with the app
        _translatedText = 'Please enter text to translate.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final translatedText = await translateText(
      _textController.text,
      _selectedLanguage,
    );

    setState(() {
      _translatedText = translatedText;
      _isLoading = false;
    });
  }

  Future<String> translateText(String text, String targetLanguage) async {
    const apiKey =
        'AIzaSyCiAifLjsjDhDtcWg5H8kl5b_K45JB5nxQ'; //This is my API key, using Google Cloud Translation API
    final apiUrl =
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey&q=$text&target=$targetLanguage';

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['translations'][0]['translatedText'];
      } else {
        print('Translation API Error: ${response.statusCode}');
        return 'Translation failed.';
      }
    } catch (e) {
      print('Error: $e');
      return 'Translation failed.';
    }
  }

  // Function to convert translated text to speech
  //This is an additional feature to further assist the user in understanding the translated text in a audio format
  Future<void> _speakTranslatedText() async {
    if (_translatedText.isEmpty) {
      return;
    }

    // This is setting the language for TTS based on the selected language
    String ttsLanguage = _selectedLanguage; // Default to selected language
    if (_selectedLanguage == 'es') {
      ttsLanguage = 'es-ES'; // Spanish (Spain)
    } else if (_selectedLanguage == 'fr') {
      ttsLanguage = 'fr-FR'; // French (France)
    } else if (_selectedLanguage == 'sn') {
      ttsLanguage = 'sn-ZW'; // Shona (Zimbabwe)
    } else if (_selectedLanguage == 'nr') {
      ttsLanguage = 'nr-ZA'; // Ndebele (South Africa)
    } else if (_selectedLanguage == 'ee') {
      ttsLanguage = 'ee-GH'; // Ewe (Ghana)
    }

    await flutterTts.setLanguage(ttsLanguage); // Setting TTS language
    await flutterTts.speak(_translatedText); // Speaking the translated text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        title: Text(
          'English to Language Translator',
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 20, // Font size
          ),
        ),
        backgroundColor: Colors.blue[800], 
        centerTitle: true, 
      ),
      body: SingleChildScrollView(
        // Allowing for the scrolling on smaller screens
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 22), 
              Text(
                //small message explaining what the app is and what it does.
                'This is a simple English to Language Translator app. It also includes a feature to allow one to listen to the translated text. Enjoy!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800], 
                ),
                textAlign: TextAlign.center, 
              ),
              SizedBox(height: 40), 
              // Input Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24), 
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Enter English Text',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.text_fields, color: Colors.blue),
                        ),
                      ),
                      Divider(height: 20, thickness: 1),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Target Language',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.language, color: Colors.blue),
                        ),
                        value: _selectedLanguage,
                        items: _languages.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                        menuMaxHeight: 300, // Setting a maximum height for the dropdown menu, i couldnt add more languages as this was messing with widgets
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40), 
              // Translate Button
              Container(
                height: 60, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue[800]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Translate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        ),
                ),
              ),
              SizedBox(height: 40), 
              // Translated Text Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24), 
                  child: Column(
                    children: [
                      Text(
                        'Translated Text:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 20), 
                      Text(
                        _translatedText,
                        style: TextStyle(fontSize: 18), 
                      ),
                      SizedBox(height: 20), 
                      ElevatedButton(
                        onPressed: _speakTranslatedText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Listen to Translation',
                          //basically, the user can listen to the translated text
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }
}