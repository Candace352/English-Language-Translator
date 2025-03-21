# English Language Translator Application 🌐🗣️🌍

## Goal of this application
This device was developed by someone who is passionate about languages and committed to bridging gaps in communication among people who speak various languages. The concept is to offer a simpler way for people to communicate effectively even though they do not share the same language. English was employed as the default input language because it is popular worldwide and widely used, thus it was considered a common reference point to translate from.

## How It Works
**1. Input English Text:** The user types in the English text they want to translate.

**2. Select Target Language:** The user selects the desired target language from a dropdown menu. Currently, the app supports the following languages:
  - Spanish (Español)
  - French (Français)
  - Shona (ChiShona)
  - Ndebele (isiNdebele)
  - Ewe (Èʋegbe)

**3. Translate:** The app uses the Google Cloud Translation API to translate the input text into the selected language.

**4. Listen to Translation:** The translated text can be converted into speech using the Text-to-Speech (TTS) feature. The TTS language is dynamically set based on the selected target language.

# Technologies Used 🛠️👩🏻‍💻

**Flutter:**
The app is built using Flutter, a powerful framework for building cross-platform applications. Flutter provides a rich set of widgets and tools for creating beautiful and responsive user interfaces.

**Google Cloud Translation API:**
The app integrates with the Google Cloud Translation API to perform text translation. The API is accessed via HTTP POST requests, and the translated text is extracted from the JSON response.

**Text-to-Speech (TTS):**
The flutter_tts package is used to convert the translated text into speech. The TTS language is dynamically set based on the selected target language.

**HTTP Package:**
The http package is used to send HTTP requests to the Google Cloud Translation API and handle the responses.

**Material Design:**
The app follows Material Design guidelines, ensuring a consistent and visually appealing user experience.
