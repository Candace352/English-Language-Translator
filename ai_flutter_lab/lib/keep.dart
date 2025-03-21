// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_tts/flutter_tts.dart'; // Import the TTS package

// void main() {
//   runApp(TranslatorApp());
// }

// class TranslatorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'English to Language Translator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TranslationScreen(),
//     );
//   }
// }

// class TranslationScreen extends StatefulWidget {
//   @override
//   _TranslationScreenState createState() => _TranslationScreenState();
// }

// class _TranslationScreenState extends State<TranslationScreen> {
//   final TextEditingController _textController = TextEditingController();
//   String _translatedText = '';
//   bool _isLoading = false;
//   String _selectedLanguage = 'es'; // Default language is Spanish
//   final FlutterTts flutterTts = FlutterTts(); // Initialize TTS

//   // List of supported languages
//   final Map<String, String> _languages = {
//     'es': 'Spanish (Español)',
//     'fr': 'French (Français)',
//     'de': 'German (Deutsch)',
//     'it': 'Italian (Italiano)',
//     'ja': 'Japanese (日本語)',
//     // Add more languages as needed
//   };

//   Future<void> _translateText() async {
//     if (_textController.text.isEmpty) {
//       setState(() {
//         _translatedText = 'Please enter text to translate.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final translatedText = await translateText(
//       _textController.text,
//       _selectedLanguage,
//     );

//     setState(() {
//       _translatedText = translatedText;
//       _isLoading = false;
//     });
//   }

//   Future<String> translateText(String text, String targetLanguage) async {
//     const apiKey =
//         'AIzaSyDAf698NW5QwZlgSpv9mj-3io-WG-W_UhE'; // Replace with your actual API key
//     final apiUrl =
//         'https://translation.googleapis.com/language/translate/v2?key=$apiKey&q=$text&target=$targetLanguage';

//     try {
//       final response = await http.post(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         return jsonResponse['data']['translations'][0]['translatedText'];
//       } else {
//         print('Translation API Error: ${response.statusCode}');
//         return 'Translation failed.';
//       }
//     } catch (e) {
//       print('Error: $e');
//       return 'Translation failed.';
//     }
//   }

//   // Function to convert translated text to speech
//   Future<void> _speakTranslatedText() async {
//     if (_translatedText.isEmpty) {
//       return;
//     }

//     // Set the language for TTS based on the selected language
//     String ttsLanguage = _selectedLanguage; // Default to selected language
//     if (_selectedLanguage == 'es') {
//       ttsLanguage = 'es-ES'; // Spanish (Spain)
//     } else if (_selectedLanguage == 'fr') {
//       ttsLanguage = 'fr-FR'; // French (France)
//     } else if (_selectedLanguage == 'de') {
//       ttsLanguage = 'de-DE'; // German (Germany)
//     } else if (_selectedLanguage == 'it') {
//       ttsLanguage = 'it-IT'; // Italian (Italy)
//     } else if (_selectedLanguage == 'ja') {
//       ttsLanguage = 'ja-JP'; // Japanese (Japan)
//     }

//     await flutterTts.setLanguage(ttsLanguage); // Set TTS language
//     await flutterTts.speak(_translatedText); // Speak the translated text
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('English to Language Translator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 labelText: 'Enter English Text',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 labelText: 'Select Target Language',
//                 border: OutlineInputBorder(),
//               ),
//               value: _selectedLanguage,
//               items: _languages.entries.map((entry) {
//                 return DropdownMenuItem(
//                   value: entry.key,
//                   child: Text(entry.value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedLanguage = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _translateText,
//                     child: Text('Translate'),
//                   ),
//             SizedBox(height: 20),
//             Text(
//               'Translated Text:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               _translatedText,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _speakTranslatedText,
//               child: Text('Listen to Translation'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
