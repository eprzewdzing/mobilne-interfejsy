import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Projekt3Screen extends StatefulWidget {
  const Projekt3Screen({super.key});

  @override
  State<Projekt3Screen> createState() => _Projekt3Screen();
}

class _Projekt3Screen extends State<Projekt3Screen> {
  final TextEditingController _numberController = TextEditingController();

  String _output = '';
  int? _number;

  String _selectedFormat = 'szesnastkowy';

  final List<Map<String, String>> formats = [
    {'value': 'szesnastkowy', 'label': 'Szesnastkowy (HEX)'},
    {'value': 'ósemkowy', 'label': 'Ósemkowy (OCT)'},
    {'value': 'trójkowy', 'label': 'Trójkowy (TERN)'},
    {'value': 'binarny', 'label': 'Binarny (BIN)'},
  ];

  static const int minValue = -100000000;
  static const int maxValue = 100000000;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _convertNumber() {
    final input = _numberController.text.trim();

    if (input.isEmpty) {
      _showError('Wprowadź liczbę całkowitą');
      return;
    }

    final parsed = int.tryParse(input);
    if (parsed == null) {
      _showError('Nieprawidłowa liczba całkowita');
      return;
    }

    if (parsed < minValue || parsed > maxValue) {
      _showError('Liczba musi być z zakresu:\n$minValue do $maxValue');
      return;
    }

    setState(() {
      _number = parsed;
      _updateOutput();
    });
  }

  void _updateOutput() {
    if (_number == null) {
      _output = '';
      return;
    }

    final n = _number!;

    switch (_selectedFormat) {
      case 'szesnastkowy':
        _output = '0x${n.toRadixString(16).toUpperCase()}';
        break;

      case 'ósemkowy':
        _output = '0${n.toRadixString(8)}';
        break;

      case 'trójkowy':
        _output = _toTernary(n);
        break;

      case 'binarny':
        String bin = n.abs().toRadixString(2);
        int padding = (4 - bin.length % 4) % 4;
        bin = '0' * padding + bin;

        _output = RegExp(r'.{1,4}')
            .allMatches(bin)
            .map((m) => m.group(0)!)
            .join(' ');

        if (n < 0) _output = '- $_output';
        break;
    }
  }

  String _toTernary(int number) {
    if (number == 0) return '0';

    final bool isNegative = number < 0;
    int absNumber = number.abs();

    String ternary = '';
    while (absNumber > 0) {
      ternary = (absNumber % 3).toString() + ternary;
      absNumber ~/= 3;
    }

    return isNegative ? '- $ternary' : ternary;
  }

  void _onFormatChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFormat = value;
        if (_number != null) {
          _updateOutput();
        }
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearAll() {
    setState(() {
      _numberController.clear();
      _number = null;
      _output = '';
    });
  }

  void _showInstructionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instrukcja'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('1. Wpisz liczbę całkowitą.'),
                Text('2. Wybierz żądany format.'),
                Text('3. Naciśnij przycisk "Konwertuj".'),
                Text('4. Możesz zmienić format w dowolnym momencie – wynik zaktualizuje się automatycznie.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liczba w różnych formatach'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Wprowadź liczbę całkowitą i wybierz format',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _numberController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
              ],
              decoration: const InputDecoration(
                labelText: 'Liczba całkowita',
                border: OutlineInputBorder(),
                helperText: 'Zakres: -100000000 do 100000000',
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Wybierz format wyjściowy:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            RadioGroup<String>(
              groupValue: _selectedFormat,
              onChanged: _onFormatChanged,
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: formats.map((format) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width > 600
                        ? 300
                        : double.infinity,
                    child: RadioListTile<String>(
                      value: format['value']!,
                      title: Text(format['label']!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _convertNumber,
              child: const Text('Konwertuj'),
            ),

            const SizedBox(height: 24),

            if (_output.isNotEmpty) ...[
              const Text(
                'Wynik:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  _output,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            OutlinedButton(
              onPressed: _clearAll,
              child: const Text('Wyczyść wszystko'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ElevatedButton.icon(
          onPressed: _showInstructionDialog,
          label: const Text('Instrukcja'),
        ),
      ),
    );
  }
}