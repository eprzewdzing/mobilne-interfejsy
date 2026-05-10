import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Projekt9Screen extends StatefulWidget {
  const Projekt9Screen({super.key});

  @override
  State<Projekt9Screen> createState() => _Projekt9ScreenState();
}

class HashPrefixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    if (!text.startsWith('#')) {
      text = '#$text';
    }

    if (text.isEmpty || text[0] != '#') {
      text = '#';
    }

    if (text.length > 7) {
      text = text.substring(0, 7);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _Projekt9ScreenState extends State<Projekt9Screen> {
  final TextEditingController _textController = TextEditingController();

  Color _backgroundColor = Colors.white;

  void _changeColor(String value) {
    value = value.trim();

    if (RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
      final hexColor = value.substring(1);

      setState(() {
        _backgroundColor = Color(
          int.parse('FF$hexColor', radix: 16),
        );
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Zmiana tła'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Wpisz w polu tekstowym kod szesnastkowy wybranego koloru, a tło zmieni się automatycznie.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Kod szesnastkowy',
                      hintText: '#000000',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      HashPrefixFormatter(),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f#]')),
                    ],
                    onChanged: _changeColor,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Przykłady:\n#FF0000\n#00FF00\n#0000FF',
                    textAlign: TextAlign.center,
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