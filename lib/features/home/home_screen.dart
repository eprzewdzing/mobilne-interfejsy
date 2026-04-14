import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Projekty'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,           // 2 kolumny
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            final projects = [
              {
                'title': 'Kalkulator przesunięcia daty',
                'route': '/projekt1',
              },
              {
                'title': 'Kalkulator różnicy dat',
                'route': '/projekt2',
              },
              {
                'title': 'Liczba całkowita w różnych formatach',
                'route': '/projekt3',
              },
              {
                'title': 'Obszar mapy - współrzędne',
                'route': '/projekt4',
              },
              {
                'title': 'Prezentacja dwóch list',
                'route': '/projekt5',
              },
            ];

            final project = projects[index];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pushNamed(context, project['route'] as String);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      project['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}