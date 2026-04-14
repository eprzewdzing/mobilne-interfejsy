import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Projekt4Screen extends StatefulWidget {
  const Projekt4Screen({super.key});

  @override
  State<Projekt4Screen> createState() => _Projekt4Screen();
}

class _Projekt4Screen extends State<Projekt4Screen> {
  final MapController mapController = MapController();

  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  LatLng currentCenter = const LatLng(51.7584, 19.4460);
  double currentZoom = 10.0;

  @override
  void initState() {
    super.initState();
    latController.text = currentCenter.latitude.toStringAsFixed(6);
    lngController.text = currentCenter.longitude.toStringAsFixed(6);
  }

  @override
  void dispose() {
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  void _updateMap() {
    final double? lat = double.tryParse(latController.text.trim());
    final double? lng = double.tryParse(lngController.text.trim());

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Podaj poprawne współrzędne.'),
        ),
      );
      return;
    }

    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Szerokość musi być z przedziału -90 do 90\nDługość z przedziału -180 do 180',
          ),
        ),
      );
      return;
    }

    setState(() {
      currentCenter = LatLng(lat, lng);
    });

    mapController.move(currentCenter, currentZoom);
  }

  void _zoomIn() {
    final newZoom = (currentZoom + 1).clamp(3.0, 18.0);
    setState(() => currentZoom = newZoom);
    mapController.move(currentCenter, newZoom);
  }

  void _zoomOut() {
    final newZoom = (currentZoom - 1).clamp(3.0, 18.0);
    setState(() => currentZoom = newZoom);
    mapController.move(currentCenter, newZoom);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Obszar mapy — współrzędne'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Współrzędne centrum mapy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Szerokość',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: lngController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Długość',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _updateMap,
                        icon: const Icon(Icons.location_on),
                        label: const Text('Pokaż obszar na mapie'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: currentCenter,
                    initialZoom: currentZoom,
                    minZoom: 3,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.zadanie1',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentCenter,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: _zoomIn,
                        heroTag: "zoomIn",
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        onPressed: _zoomOut,
                        heroTag: "zoomOut",
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}