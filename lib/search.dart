import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _facilities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndFacilities();
  }

  Future<void> _getCurrentLocationAndFacilities() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;

      setState(() {
        _markers = [
          Marker(
            point: LatLng(position.latitude, position.longitude),
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ];
      });

      // Fetch nearby facilities
      await _fetchNearbyFacilities(position);
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchNearbyFacilities(Position position) async {
    try {
      // Using Overpass API for more accurate results
      final query = '''
        [out:json][timeout:25];
        (
          // General Hospitals
          way["amenity"="hospital"]["healthcare"!="rehabilitation"](around:10000,${position.latitude},${position.longitude});
          node["amenity"="hospital"]["healthcare"!="rehabilitation"](around:10000,${position.latitude},${position.longitude});
          
          // General Medical Clinics (excluding specific specialties)
          way["amenity"="clinic"]["healthcare"="clinic"](around:10000,${position.latitude},${position.longitude});
          node["amenity"="clinic"]["healthcare"="clinic"](around:10000,${position.latitude},${position.longitude});
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.get(
        Uri.parse(
            'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}'),
        headers: {
          'User-Agent': 'CtrlZed/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        setState(() {
          // Clear previous markers except current location
          _markers = [_markers.first];

          // Process facilities
          _facilities = elements
              .where((element) {
                if (!element.containsKey('tags')) return false;
                final tags = element['tags'] as Map;

                // Exclude unwanted specialties
                final specialties = [
                  // Medical specialties
                  'dermatology', 'derma', 'skin',
                  'physiotherapy', 'physical therapy', 'physical_therapy',
                  'rehabilitation', 'rehab',
                  'ultrasound', 'diagnostic',
                  'laboratory', 'lab',
                  'ob', 'gyne', 'obstetrics', 'gynecology', 'maternity',
                  'pediatric', 'children',
                  'dental', 'dentist',
                  'eye', 'optical', 'ophthalmology',
                  'orthopedic', 'surgery',

                  // Beauty and wellness related
                  'aesthetic', 'aesthetics',
                  'beauty', 'beauti',
                  'cosmetic', 'cosmet',
                  'slimming', 'slim',
                  'wellness',
                  'spa',
                  'facial',
                  'laser',
                  'botox',
                  'plastic',
                  'rejuv',
                  'anti-aging',
                  'anti aging',
                  'skin care',
                  'skincare',
                  'face',
                  'body',
                  'massage',
                  'therapy',
                  'salon',
                  'treatment',
                  'enhancement',
                  'liposuction',
                  'weight loss',
                  'diet',
                ];

                // Get all relevant text fields to check
                final name = (tags['name'] ?? '').toString().toLowerCase();
                final healthcare =
                    (tags['healthcare'] ?? '').toString().toLowerCase();
                final specialization = (tags['healthcare:speciality'] ?? '')
                    .toString()
                    .toLowerCase();
                final description =
                    (tags['description'] ?? '').toString().toLowerCase();
                final operator =
                    (tags['operator'] ?? '').toString().toLowerCase();

                // Check all text fields for specialty keywords
                for (final specialty in specialties) {
                  if (name.contains(specialty) ||
                      healthcare.contains(specialty) ||
                      specialization.contains(specialty) ||
                      description.contains(specialty) ||
                      operator.contains(specialty)) {
                    return false;
                  }
                }

                // Only include general hospitals and clinics
                return (tags['amenity'] == 'hospital' ||
                    (tags['amenity'] == 'clinic' &&
                        !tags.containsKey(
                            'healthcare:speciality') && // Exclude if has speciality
                        !name.contains(
                            'specialist') && // Exclude specialist clinics
                        !name.contains(
                            'center') && // Often indicates specialty center
                        !name.contains('centre') &&
                        !name.contains('aesthetic') &&
                        !name.contains('beauty') &&
                        !name.contains('skin') &&
                        !tags.containsKey('beauty') && // Check for beauty tag
                        !tags.containsKey(
                            'service:beauty') && // Check for beauty services
                        tags['healthcare'] !=
                            'beauty' && // Exclude beauty healthcare
                        !operator.contains('beauty') && // Check operator name
                        !operator
                            .contains('aesthetic'))); // Check operator name
              })
              .map<Map<String, dynamic>>((element) {
                final lat = element['lat'] is int
                    ? element['lat'].toDouble()
                    : element['lat'] ?? element['center']?['lat'];
                final lon = element['lon'] is int
                    ? element['lon'].toDouble()
                    : element['lon'] ?? element['center']?['lon'];

                if (lat == null || lon == null) return {'skip': true};

                final distance = Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  lat,
                  lon,
                );

                // Skip facilities that are too far
                if (distance > 10000) {
                  return {'skip': true};
                }

                final tags = element['tags'] as Map;
                final name = tags['name'] ?? 'Medical Facility';
                final isHospital = tags['amenity'] == 'hospital' ||
                    tags['healthcare'] == 'hospital' ||
                    name.toString().toLowerCase().contains('hospital');

                // Add marker for this facility
                _markers.add(
                  Marker(
                    point: LatLng(lat, lon),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isHospital
                              ? Icons.local_hospital
                              : Icons.medical_services,
                          color: isHospital ? Colors.red : Colors.orange,
                          size: isHospital ? 35 : 30,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isHospital
                                ? Colors.red.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 80,
                              maxWidth: 200,
                            ),
                            child: Text(
                              name.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isHospital
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                return {
                  'name': name,
                  'type': isHospital ? 'Hospital' : 'Medical Facility',
                  'address': tags['addr:street'] ??
                      tags['address'] ??
                      'Address not available',
                  'distance': distance,
                  'amenity': isHospital ? 'hospital' : 'clinic',
                  'isHospital': isHospital,
                };
              })
              .where((f) => !f.containsKey('skip'))
              .toList()
            ..sort((a, b) {
              if (a['isHospital'] && !b['isHospital']) return -1;
              if (!a['isHospital'] && b['isHospital']) return 1;
              return a['distance'].compareTo(b['distance']);
            });
        });
      }
    } catch (e) {
      print('Error fetching facilities: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: const Text('Nearby Medical Facilities'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Map section
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _currentPosition != null
                            ? LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              )
                            : const LatLng(14.5995, 120.9842),
                        zoom: 14,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(markers: _markers),
                      ],
                    ),
                  ),
                ),

                // Facilities list section
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Nearby Facilities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),

                // List of facilities
                _facilities.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('No medical facilities found nearby'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final facility = _facilities[index];
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: facility['amenity'] == 'hospital'
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      facility['amenity'] == 'hospital'
                                          ? Icons.local_hospital
                                          : Icons.medical_services,
                                      color: facility['amenity'] == 'hospital'
                                          ? Colors.red
                                          : Colors.orange,
                                      size: facility['amenity'] == 'hospital'
                                          ? 28
                                          : 24,
                                    ),
                                  ),
                                  title: Text(
                                    facility['name'],
                                    style: TextStyle(
                                      fontWeight:
                                          facility['amenity'] == 'hospital'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        facility['type'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '${(facility['distance'] / 1000).toStringAsFixed(1)} km away',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    final marker = _markers[index + 1];
                                    _mapController.move(marker.point, 16);
                                  },
                                ),
                                if (index < _facilities.length - 1)
                                  const Divider(height: 1),
                              ],
                            );
                          },
                          childCount: _facilities.length,
                        ),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[100],
        child: const Icon(Icons.my_location, color: Colors.black87),
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              14,
            );
          }
        },
      ),
    );
  }
}
