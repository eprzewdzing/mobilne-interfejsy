import 'package:flutter/material.dart';

class Projekt8Screen extends StatefulWidget {
  const Projekt8Screen({super.key});

  @override
  State<Projekt8Screen> createState() => _Projekt8ScreenState();
}

class _Projekt8ScreenState extends State<Projekt8Screen> {
  final TextEditingController _passwordController = TextEditingController();

  int minLength = 8;
  int minDigits = 2;
  int minSpecialChars = 1;

  String resultMessage = "";

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void validatePassword() {
    String password = _passwordController.text;

    int digitCount =
        RegExp(r'\d').allMatches(password).length;

    int specialCharCount =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]')
            .allMatches(password)
            .length;

    List<String> errors = [];

    if (password.length < minLength) {
      errors.add(
          "Hasło musi mieć minimum $minLength znaków.");
    }

    if (digitCount < minDigits) {
      errors.add(
          "Hasło musi zawierać minimum $minDigits cyfr.");
    }

    if (specialCharCount < minSpecialChars) {
      errors.add(
          "Hasło musi zawierać minimum $minSpecialChars znaków specjalnych.");
    }

    setState(() {
      if (errors.isEmpty) {
        resultMessage = "Hasło jest poprawne.";
      } else {
        resultMessage = errors.join("\n");
      }
    });
  }

  void showLimitsDialog() {
    int selectedLength = minLength;
    int selectedDigits = minDigits;
    int selectedSpecial = minSpecialChars;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Ustaw limity hasła"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Minimalna długość"),
                      DropdownButton<int>(
                        value: selectedLength,
                        items: List.generate(
                          21,
                              (index) => DropdownMenuItem(
                            value: index + 4,
                            child: Text("${index + 4}"),
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedLength = value!;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Ilość cyfr"),
                      DropdownButton<int>(
                        value: selectedDigits,
                        items: List.generate(
                          11,
                              (index) => DropdownMenuItem(
                            value: index,
                            child: Text("$index"),
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedDigits = value!;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Znaki specjalne"),
                      DropdownButton<int>(
                        value: selectedSpecial,
                        items: List.generate(
                          11,
                              (index) => DropdownMenuItem(
                            value: index,
                            child: Text("$index"),
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedSpecial = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Anuluj"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      minLength = selectedLength;
                      minDigits = selectedDigits;
                      minSpecialChars = selectedSpecial;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Zapisz"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Okno dialogowe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ustaw limity hasła, wpisz wybrane hasło w polu tekstowym i sprawdź jego poprawność.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Wpisz hasło",
                  border: OutlineInputBorder(),
                ),
              ),
        
              const SizedBox(height: 20),
        
              ElevatedButton(
                onPressed: validatePassword,
                child: const Text("Sprawdź hasło"),
              ),
        
              const SizedBox(height: 10),
        
              ElevatedButton(
                onPressed: showLimitsDialog,
                child: const Text("Ustaw limity hasła"),
              ),
        
              const SizedBox(height: 20),

              if (resultMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: resultMessage == "Hasło jest poprawne."
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    border: Border.all(
                      color: resultMessage == "Hasło jest poprawne."
                          ? Colors.green
                          : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        resultMessage == "Hasło jest poprawne."
                            ? Icons.check_circle
                            : Icons.error,
                        color: resultMessage == "Hasło jest poprawne."
                            ? Colors.green
                            : Colors.red,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          resultMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: resultMessage == "Hasło jest poprawne."
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.settings, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Aktualne limity",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Minimalna długość: $minLength",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Ilość cyfr: $minDigits",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Ilość znaków specjalnych: $minSpecialChars",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}