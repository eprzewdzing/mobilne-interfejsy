import 'package:flutter/material.dart';

class Projekt2Screen extends StatefulWidget {
  const Projekt2Screen({super.key});

  @override
  State<Projekt2Screen> createState() => _Projekt2ScreenState();
}

class _Projekt2ScreenState extends State<Projekt2Screen> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatDateTime(DateTime d) {
    return '${d.year}-${_two(d.month)}-${_two(d.day)} '
        '${_two(d.hour)}:${_two(d.minute)}:${_two(d.second)}';
  }

  Future<DateTime?> _pickDateTime({DateTime? initial}) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;

    final pickedDateTime = await _pickTimeWithSeconds(initial ?? now);
    if (pickedDateTime == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      pickedDateTime.hour,
      pickedDateTime.minute,
      pickedDateTime.second,
    );
  }

  Future<DateTime?> _pickTimeWithSeconds(DateTime initial) async {
    int hour = initial.hour;
    int minute = initial.minute;
    int second = initial.second;

    return await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wybierz czas (z sekundami)'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<int>(
                        value: hour,
                        items: List.generate(24, (i) => i)
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().padLeft(2, '0')),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => hour = val!);
                        },
                      ),
                      DropdownButton<int>(
                        value: minute,
                        items: List.generate(60, (i) => i)
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().padLeft(2, '0')),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => minute = val!);
                        },
                      ),
                      DropdownButton<int>(
                        value: second,
                        items: List.generate(60, (i) => i)
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().padLeft(2, '0')),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => second = val!);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  DateTime(0, 1, 1, hour, minute, second),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _calculateDifference() {
    if (_startDateTime == null) {
      _showError('Wybierz datę początkową.');
      return;
    }
    if (_endDateTime == null) {
      _showError('Wybierz datę końcową.');
      return;
    }

    Duration diff = _endDateTime!.difference(_startDateTime!);

    if (diff.isNegative) {
      diff = diff.abs();
    }

    setState(() {
      _daysController.text = diff.inDays.toString();
      _hoursController.text = (diff.inHours % 24).toString();
      _minutesController.text = (diff.inMinutes % 60).toString();
      _secondsController.text = (diff.inSeconds % 60).toString();
    });
  }

  Widget _buildDateTimeField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildResultField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
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
                Text('1. Wybierz datę początkową i końcową.'),
                Text('2. Ustaw godziny, minuty i sekundy'),
                Text('3. Kliknij "Oblicz"'),
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
        title: const Text('Kalkulator różnicy dat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Wybierz datę początkową i końcową',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildDateTimeField(
              label: 'Data początkowa',
              controller: _startController,
              onTap: () async {
                final picked = await _pickDateTime(initial: _startDateTime);
                if (picked != null) {
                  setState(() {
                    _startDateTime = picked;
                    _startController.text = _formatDateTime(picked);
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            _buildDateTimeField(
              label: 'Data końcowa',
              controller: _endController,
              onTap: () async {
                final picked = await _pickDateTime(initial: _endDateTime);
                if (picked != null) {
                  setState(() {
                    _endDateTime = picked;
                    _endController.text = _formatDateTime(picked);
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _calculateDifference,
              child: const Text('Oblicz'),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildResultField(
                    label: 'Dni',
                    controller: _daysController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildResultField(
                    label: 'Godziny',
                    controller: _hoursController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildResultField(
                    label: 'Minuty',
                    controller: _minutesController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildResultField(
                    label: 'Sekundy',
                    controller: _secondsController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                setState(() {
                  _startDateTime = null;
                  _endDateTime = null;
                  _startController.clear();
                  _endController.clear();
                  _daysController.clear();
                  _hoursController.clear();
                  _minutesController.clear();
                  _secondsController.clear();
                });
              },
              child: const Text('Wyczyść'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: ElevatedButton(
          onPressed: _showInstructionDialog,
          child: const Text('Instrukcja'),
        ),
      ),
    );
  }
}