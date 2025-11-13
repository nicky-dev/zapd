import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class StallLocationPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? initialName;

  const StallLocationPicker({super.key, this.initialLat, this.initialLng, this.initialName});

  @override
  State<StallLocationPicker> createState() => _StallLocationPickerState();
}

class _StallLocationPickerState extends State<StallLocationPicker> {
  late MapController _mapController;
  LatLng? _selected;
  String? _selectedName;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selected = LatLng(widget.initialLat!, widget.initialLng!);
    }
    _selectedName = widget.initialName;
  }

  Future<void> _search(String q) async {
    if (q.trim().isEmpty) return;
    setState(() { _loading = true; _searchResults = []; });
    final uri = Uri.parse('https://nominatim.openstreetmap.org/search')
        .replace(queryParameters: {
      'q': q,
      'format': 'json',
      'limit': '6',
    });
    final resp = await http.get(uri, headers: {
      'User-Agent': 'ZapD/1.0 (merchant app)'
    });
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      if (!mounted) return;
      setState(() { _searchResults = data; _loading = false; });
    } else {
      if (!mounted) return;
      setState(() { _loading = false; });
    }
  }

  Future<void> _useCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.useCurrentLocation)));
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.useCurrentLocation)));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.useCurrentLocation)));
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if (!mounted) return;
    setState(() {
      _selected = LatLng(pos.latitude, pos.longitude);
      _selectedName = AppLocalizations.of(context)!.currentLocation;
    });
    _mapController.move(_selected!, 15);
  }

  void _onTapMap(TapPosition tap, LatLng latlng) {
    setState(() {
      _selected = latlng;
      _selectedName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final center = _selected ?? LatLng(13.7563, 100.5018); // Bangkok default
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Builder(builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchPlace,
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onSubmitted: _search,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _useCurrentLocation,
                  tooltip: AppLocalizations.of(context)!.useCurrentLocation,
                ),
              ],
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          if (_searchResults.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  final display = item['display_name'] ?? item['name'] ?? '';
                  final lat = double.tryParse(item['lat'] ?? '') ;
                  final lon = double.tryParse(item['lon'] ?? '');
                  return ListTile(
                      title: Text(display),
                    subtitle: Text('lat: ${item['lat']}, lon: ${item['lon']}'),
                    onTap: () {
                      if (lat != null && lon != null) {
                        setState(() {
                          _selected = LatLng(lat, lon);
                          _selectedName = display;
                          _searchResults = [];
                          _searchController.clear();
                        });
                        _mapController.move(_selected!, 15);
                      }
                    },
                  );
                },
              ),
            ),
          SizedBox(
            height: 300,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 13,
                onTap: _onTapMap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                if (_selected != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selected!,
                        width: 60,
                        height: 60,
                        child: const Icon(Icons.location_on, size: 44, color: Colors.red),
                      )
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(_selectedName ?? (_selected != null ? '${_selected!.latitude.toStringAsFixed(6)}, ${_selected!.longitude.toStringAsFixed(6)}' : AppLocalizations.of(context)!.noLocationSelected)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          Navigator.of(context).pop({
                            'latitude': _selected!.latitude,
                            'longitude': _selected!.longitude,
                            'name': _selectedName,
                          });
                        },
                  child: Text(AppLocalizations.of(context)!.select),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
