import 'package:flutter/material.dart';
import '../models/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsPage extends StatefulWidget {
  final PlaceModel place;

  const PlaceDetailsPage({Key? key, required this.place}) : super(key: key);

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;

  final Map<String, Map<String, dynamic>> cityInfo = {
    "Istanbul": {
      "description":
          "Istanbul is Turkey's most populous city and economic, cultural and historic center. Located on both sides of the Bosphorus, it bridges Europe and Asia.",
      "highlights": "Hagia Sophia, Blue Mosque, Grand Bazaar, Bosphorus Bridge",
      "bestTime": "April-May, September-November",
      "lat": 41.0082,
      "lng": 28.9784,
    },
    "Ankara": {
      "description":
          "Ankara is the capital city of Turkey, known for its government buildings and rich history.",
      "highlights":
          "Anıtkabir, Museum of Anatolian Civilizations, Kocatepe Mosque",
      "bestTime": "April to June, September to November",
      "lat": 39.9334,
      "lng": 32.8597,
    },
    "Antalya": {
      "description":
          "Antalya is a Turkish resort city with a yacht-filled Old Harbor and beaches flanked by large hotels.",
      "highlights": "Old Town (Kaleiçi), Düden Waterfalls, Antalya Museum",
      "bestTime": "May to October",
      "lat": 36.8969,
      "lng": 30.7133,
    },
    "Alanya": {
      "description":
          "Alanya is a beach resort city on Turkey’s southern coast, known for its castle and lively nightlife.",
      "highlights": "Alanya Castle, Cleopatra Beach, Red Tower",
      "bestTime": "May to October",
      "lat": 36.5413,
      "lng": 32.0006,
    },
    "Fethiye": {
      "description":
          "Fethiye is a port city on Turkey’s Turquoise Coast, known for natural harbor, blue waters, and nearby ancient ruins.",
      "highlights": "Ölüdeniz Beach, Saklıkent Gorge, Kayaköy",
      "bestTime": "April to October",
      "lat": 36.6214,
      "lng": 29.1199,
    },
    "Eskişehir": {
      "description":
          "Eskişehir is a modern city known for its university and vibrant cultural scene.",
      "highlights": "Odunpazarı Historic District, Porsuk River, Sazova Park",
      "bestTime": "April to October",
      "lat": 39.7767,
      "lng": 30.5206,
    },
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isAppBarExpanded =
            _scrollController.hasClients && _scrollController.offset < 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> openGoogleMapsDirections() async {
    try {
      Position position = await _getCurrentLocation();
      final double originLat = position.latitude;
      final double originLng = position.longitude;

      final destination = cityInfo[widget.place.name];
      if (destination == null) {
        throw Exception('Destination info not found');
      }
      final double destLat = destination["lat"];
      final double destLng = destination["lng"];

      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng&travelmode=driving',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      print('Error opening directions: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open Google Maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final info =
        cityInfo[widget.place.name] ??
        {
          "description": widget.place.description,
          "highlights": "Various attractions and landmarks",
          "bestTime": "Year-round",
          "lat": 0.0,
          "lng": 0.0,
        };

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.blue,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Share ${widget.place.name}'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: _isAppBarExpanded
                  ? null
                  : Text(
                      widget.place.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              background: Hero(
                tag: "place_${widget.place.name}",
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.place.imagePath),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {},
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 5),
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "Turkey",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  _buildSectionTitle("About"),
                  SizedBox(height: 10),
                  Text(
                    info["description"]!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSectionTitle("Highlights"),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_border, color: Colors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            info["highlights"]!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSectionTitle("Best Time to Visit"),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            info["bestTime"]!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to favorites!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: Icon(Icons.favorite_border),
                          label: Text('Add to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: Colors.red.shade800,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            openGoogleMapsDirections();
                          },
                          icon: Icon(Icons.directions),
                          label: Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
