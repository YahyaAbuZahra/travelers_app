import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String placeName;
  final String location;
  final String description;
  final String imagePath;
  final List<String> likes;
  final List<CommentModel> comments;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage = '',
    required this.placeName,
    required this.location,
    required this.description,
    required this.imagePath,
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
  });

  // تحويل من Map إلى PostModel
  factory PostModel.fromMap(Map<String, dynamic> map) {
    List<CommentModel> commentsList = [];
    if (map['comments'] != null) {
      commentsList = (map['comments'] as List)
          .map((commentMap) => CommentModel.fromMap(commentMap))
          .toList();
    }

    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      placeName: map['placeName'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      comments: commentsList,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // تحويل من PostModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'placeName': placeName,
      'location': location,
      'description': description,
      'imagePath': imagePath,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool isLikedBy(String userId) {
    return likes.contains(userId);
  }

  int get likesCount => likes.length;

  int get commentsCount => comments.length;

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImage,
    String? placeName,
    String? location,
    String? description,
    String? imagePath,
    List<String>? likes,
    List<CommentModel>? comments,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      placeName: placeName ?? this.placeName,
      location: location ?? this.location,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, userName: $userName, placeName: $placeName, location: $location, likesCount: $likesCount, commentsCount: $commentsCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.userId == userId &&
        other.placeName == placeName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ placeName.hashCode;
  }
}
