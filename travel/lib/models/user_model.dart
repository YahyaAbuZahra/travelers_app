import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final List<String> favoriteePlaces;
  final List<String> visitedPlaces;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = '',
    this.favoriteePlaces = const [],
    this.visitedPlaces = const [],
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      favoriteePlaces: List<String>.from(map['favoriteePlaces'] ?? []),
      visitedPlaces: List<String>.from(map['visitedPlaces'] ?? []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'favoriteePlaces': favoriteePlaces,
      'visitedPlaces': visitedPlaces,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    List<String>? favoriteePlaces,
    List<String>? visitedPlaces,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      favoriteePlaces: favoriteePlaces ?? this.favoriteePlaces,
      visitedPlaces: visitedPlaces ?? this.visitedPlaces,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, imageUrl: $imageUrl, favoriteePlaces: $favoriteePlaces, visitedPlaces: $visitedPlaces, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }
}
