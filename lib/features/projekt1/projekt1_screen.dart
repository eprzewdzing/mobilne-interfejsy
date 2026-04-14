import 'package:flutter/material.dart';

class Projekt1Screen extends StatefulWidget {
  const Projekt1Screen({super.key});

  @override
  State<Projekt1Screen> createState() => _Projekt1ScreenState();
}

class _Projekt1ScreenState extends State<Projekt1Screen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _offsetController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  DateTime? _selectedDate;
  String _selectedUnit = 'dni';
  final List<String> _units = ['godziny', 'dni', 'tygodni'];

  static const int _maxOffset = 1000000;

  @override
  void dispose() {
    _dateController.dispose();
    _offsetController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final combined = DateTime(picked.year, picked.month, picked.day);

      setState(() {
        _selectedDate = combined;
        _dateController.text = _formatDate(combined);
      });
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _calculate() {
    if (_selectedDate == null) {
      _showError('Wybierz datę początkową.');
      return;
    }

    final offsetText = _offsetController.text.trim();
    if (offsetText.isEmpty) {
      _showError('Podaj wartość przesunięcia.');
      return;
    }

    final offset = int.tryParse(offsetText);
    if (offset == null) {
      _showError('Wprowadź poprawną liczbę całkowitą.');
      return;
    }

    if (offset.abs() > _maxOffset) {
      _showError('Przekroczono maksymalne dopuszczalne przesunięcie (±$_maxOffset).');
      setState(() => _resultController.text = '');
      return;
    }

    DateTime result = _selectedDate!;

    switch (_selectedUnit) {
      case 'godziny':
        result = result.add(Duration(hours: offset));
        break;
      case 'dni':
        result = result.add(Duration(days: offset));
        break;
      case 'tygodni':
        result = result.add(Duration(days: offset * 7));
        break;
    }

    setState(() {
      _resultController.text = _formatDate(result);
    });
  }

  void pokazInstrukcje() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instrukcja'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('1. Wybierz datę początkową.'),
                Text('2. Wybierz zakres przesunięcią oraz jednostkę.'),
                Text('3. Kliknij "Przelicz.'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator przesunięcia daty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Wybierz datę i przesunięcie',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _offsetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Przesunięcie',
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedUnit,
                    items: _units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                    decoration: const InputDecoration(
                      labelText: 'Jednostka',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Przelicz'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _resultController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Wynik',
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: ElevatedButton(
          onPressed: pokazInstrukcje,
          child: const Text('Instrukcja'),
        ),
      ),
    );
  }
}