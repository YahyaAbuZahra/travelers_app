import '../models/place_model.dart';

class PlacesService {
  static List<PlaceModel> getPlaces() {
    return [
      PlaceModel(
        name: "Paris",
        imagePath: "assets/images/paris.jpg",
        description: "The city of lights and love.",
      ),
      PlaceModel(
        name: "New York",
        imagePath: "assets/images/newyork.jpg",
        description: "The city that never sleeps.",
      ),
      PlaceModel(
        name: "Tokyo",
        imagePath: "assets/images/Tokyo.jfif",
        description: "A blend of tradition and futurism.",
      ),
      PlaceModel(
        name: "London",
        imagePath: "assets/images/London.jpg",
        description: "Historic city with rich culture.",
      ),
      PlaceModel(
        name: "Sydney",
        imagePath: "assets/images/Sydney.jpg",
        description: "Famous for its harbour and opera house.",
      ),
      PlaceModel(
        name: "Rome",
        imagePath: "assets/images/rome.jpg",
        description: "Ancient city of ruins and art.",
      ),
      PlaceModel(
        name: "Barcelona",
        imagePath: "assets/images/barcelona.jpg",
        description: "Known for Gaudi's architecture.",
      ),
      PlaceModel(
        name: "Dubai",
        imagePath: "assets/images/dubai.jif",
        description: "City of skyscrapers and luxury.",
      ),
      PlaceModel(
        name: "Moscow",
        imagePath: "assets/images/moscow.jpg",
        description: "Capital of Russia with rich history.",
      ),
    ];
  }
}
