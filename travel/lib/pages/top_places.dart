import 'package:flutter/material.dart';
import '../models/place_model.dart';
import 'place_details.dart';

class TopPlaces extends StatefulWidget {
  const TopPlaces({super.key});

  @override
  State<TopPlaces> createState() => _TopPlacesState();
}

class _TopPlacesState extends State<TopPlaces> {
  final List<PlaceModel> turkishCities = [
    PlaceModel(
      name: "Istanbul",
      imagePath: "images/istanbul.jpg",
      description:
          "Istanbul is Turkey's most populous city and economic, cultural and historic center.",
    ),
    PlaceModel(
      name: "Ankara",
      imagePath: "images/Ankara.jpg",
      description:
          "Ankara is the capital city of Turkey, known for its government buildings and rich history.",
    ),
    PlaceModel(
      name: "Antalya",
      imagePath: "images/Antalya.jpeg",
      description:
          "Antalya is a Turkish resort city with a yacht-filled Old Harbor and beaches flanked by large hotels.",
    ),
    PlaceModel(
      name: "Alanya",
      imagePath: "images/Alanya.jpg",
      description:
          "Alanya is a beach resort city on Turkey’s southern coast, known for its castle and lively nightlife.",
    ),
    PlaceModel(
      name: "Fethiye",
      imagePath: "images/Fethiye.jpg",
      description:
          "Fethiye is a port city on Turkey’s Turquoise Coast, known for natural harbor, blue waters, and nearby ancient ruins.",
    ),
    PlaceModel(
      name: "Eskişehir",
      imagePath: "images/Eskişehir.jpg",
      description:
          "Eskişehir is a modern city known for its university and vibrant cultural scene.",
    ),
    PlaceModel(
      name: "Izmir",
      imagePath: "images/Izmir.jpg",
      description: "A vibrant city on Turkey's Aegean coast.",
    ),
    PlaceModel(
      name: "Cappadocia",
      imagePath: "images/Cappadocia.jpg",
      description:
          "Famous for its unique rock formations and hot air balloons.",
    ),
    PlaceModel(
      name: "Bodrum",
      imagePath: "images/Bodrum.jfif",
      description: "A lively coastal town with beautiful beaches.",
    ),
    PlaceModel(
      name: "Trabzon",
      imagePath: "images/Trabzon.jpg",
      description: "A city on the Black Sea coast with rich history.",
    ),
    PlaceModel(
      name: "Bursa",
      imagePath: "images/Bursa.jpg",
      description: "Known for its Ottoman architecture and thermal baths.",
    ),
    PlaceModel(
      name: "Konya",
      imagePath: "images/Konya.jpg",
      description:
          "A city famous for its religious heritage and Mevlana Museum.",
    ),
    PlaceModel(
      name: "Gaziantep",
      imagePath: "images/Gaziantep.jfif",
      description: "Famous for its cuisine and historical sites.",
    ),
    PlaceModel(
      name: "Kayseri",
      imagePath: "images/Kayseri.jpeg",
      description:
          "Known for its rich culinary tradition and nearby Mount Erciyes.",
    ),
    PlaceModel(
      name: "Pamukkale",
      imagePath: "images/Pamukkale.jpg",
      description:
          "Famous for its white travertine terraces and thermal waters.",
    ),
    PlaceModel(
      name: "Safranbolu",
      imagePath: "images/safranbolu.jfif",
      description: "Known for its well-preserved Ottoman houses.",
    ),
    PlaceModel(
      name: "Mardin",
      imagePath: "images/Mardin.jpg",
      description: "Historic city with unique architecture.",
    ),
  ];

  String searchQuery = "";
  List<PlaceModel> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = turkishCities;
  }

  void _filterCities(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCities = turkishCities;
      } else {
        filteredCities = turkishCities
            .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(30),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Top Places",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          theme.inputDecorationTheme.fillColor ??
                          Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: TextField(
                      onChanged: _filterCities,
                      decoration: InputDecoration(
                        hintText: "Search for places...",
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                      ),
                      style: theme.textTheme.bodyLarge,
                      cursorColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            if (searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Found ${filteredCities.length} places",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Material(
                elevation: 3.0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: filteredCities.isEmpty
                      ? _buildEmptyState(theme)
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            final place = filteredCities[index];
                            return _buildPlaceCard(place, theme);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: theme.disabledColor),
          SizedBox(height: 20),
          Text(
            "No places found",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Try searching with different keywords",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.disabledColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(PlaceModel place, ThemeData theme) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailsPage(place: place),
            ),
          );
        },
        child: Hero(
          tag: "place_${place.name}",
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  place.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.disabledColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: theme.disabledColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          place.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.disabledColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.8)
                            : Colors.black.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    place.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
