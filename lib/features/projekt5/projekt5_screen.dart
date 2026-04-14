import 'package:flutter/material.dart';

class Projekt5Screen extends StatefulWidget {
  const Projekt5Screen({super.key});

  @override
  State<Projekt5Screen> createState() => _Projekt5Screen();
}

class _Projekt5Screen extends State<Projekt5Screen> {
  List<String> pierwszaLista = [
    "Ikea",
    "Jysk",
    "Jula",
    "Obi",
    "Bodzio",
    "Castorama",
    "Black Red White",
  ];

  List<String> drugaLista = [];

  int? zaznaczonyPierwszyIndex;
  int? zaznaczonyDrugiIndex;

  void przeniesDoDrugiej() {
    if (zaznaczonyPierwszyIndex == null) return;

    setState(() {
      final element = pierwszaLista[zaznaczonyPierwszyIndex!];
      pierwszaLista.removeAt(zaznaczonyPierwszyIndex!);
      drugaLista.add(element);
      zaznaczonyPierwszyIndex = null;
    });
  }

  void przeniesDoPierwszej() {
    if (zaznaczonyDrugiIndex == null) return;

    setState(() {
      final element = drugaLista[zaznaczonyDrugiIndex!];
      drugaLista.removeAt(zaznaczonyDrugiIndex!);
      pierwszaLista.add(element);
      zaznaczonyDrugiIndex = null;
    });
  }

  void pokazInstrukcje() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Instrukcja"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('1. Wybierz element z pierwszej listy.'),
                Text('2. Przenieś go do drugiej listy przyciskiem ze strzałką w dół.'),
                Text('3. Przyciskiem ze strzałką w górę możesz przenieś element do pierwszej listy.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Zamknij"),
            )
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
        title: const Text('Prezentacja dwóch list'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Pierwsza lista",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: pierwszaLista.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(pierwszaLista[index]),
                          selected: index == zaznaczonyPierwszyIndex,
                          selectedTileColor:
                          theme.colorScheme.primary.withValues(alpha: 0.20),
                          onTap: () {
                            setState(() {
                              zaznaczonyPierwszyIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: zaznaczonyPierwszyIndex == null
                      ? null
                      : przeniesDoDrugiej,
                  child: const Icon(Icons.arrow_downward),
                ),
                ElevatedButton(
                  onPressed:
                  zaznaczonyDrugiIndex == null ? null : przeniesDoPierwszej,
                  child: const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Druga lista",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: drugaLista.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(drugaLista[index]),
                          selected: index == zaznaczonyDrugiIndex,
                          selectedTileColor:
                          theme.colorScheme.primary.withValues(alpha: 0.20),
                          onTap: () {
                            setState(() {
                              zaznaczonyDrugiIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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