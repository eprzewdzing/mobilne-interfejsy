import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Projekt7Screen extends StatefulWidget {
  const Projekt7Screen({super.key});

  @override
  State<Projekt7Screen> createState() => _Projekt7ScreenState();
}

class _Projekt7ScreenState extends State<Projekt7Screen> {
  final TextEditingController _textController = TextEditingController();

  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;

  String? errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<TextInputFormatter> _getInputFormatters() {
    return [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final insertedText = newValue.text.substring(
          oldValue.text.length,
          newValue.text.length,
        );

        for (final char in insertedText.split('')) {
          if (switchValue1 && RegExp(r'[A-Z]').hasMatch(char)) {
            _showError('Wielkie litery są zablokowane.');
            return oldValue;
          }

          if (switchValue2 && RegExp(r'[a-z]').hasMatch(char)) {
            _showError('Małe litery są zablokowane.');
            return oldValue;
          }

          if (switchValue3 && RegExp(r'[^a-zA-Z0-9]').hasMatch(char)) {
            _showError('Znaki specjalne są zablokowane.');
            return oldValue;
          }
        }

        _clearError();
        return newValue;
      }),
    ];
  }

  void _showError(String message) {
    if (errorMessage != message) {
      setState(() {
        errorMessage = message;
      });
    }
  }

  void _clearError() {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blokada wybranych znaków'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Wybierz blokady na wybrane znaki\n'
                  'i wprowadź tekst w wyznaczonym polu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _textController,
              inputFormatters: _getInputFormatters(),
              decoration: InputDecoration(
                labelText: 'Pole tekstowe',
                errorText: errorMessage,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 16, top: 10, bottom: 2),
              child: const Text(
                'Zablokuj:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SwitchListTile(
              value: switchValue1,
              title: const Text('Wielkie litery'),
              onChanged: (value) {
                setState(() {
                  switchValue1 = value;
                  _clearError();
                });
              },
            ),

            const Divider(height: 2,),

            SwitchListTile(
              value: switchValue2,
              title: const Text('Małe litery'),
              onChanged: (value) {
                setState(() {
                  switchValue2 = value;
                  _clearError();
                });
              },
            ),

            const Divider(height: 2,),

            SwitchListTile(
              value: switchValue3,
              title: const Text('Znaki inne niż alfanumeryczne'),
              onChanged: (value) {
                setState(() {
                  switchValue3 = value;
                  _clearError();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}