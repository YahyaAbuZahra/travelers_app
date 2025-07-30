import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String usersCollection = 'users';

  Future<void> addUserDetails(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    try {
      await _firestore.collection(usersCollection).doc(id).set(userInfoMap);
    } catch (e) {
      throw Exception('Error adding user details: $e');
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update(updates);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<void> addToFavorites(String userId, String placeName) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'favoriteePlaces': FieldValue.arrayUnion([placeName]),
      });
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String placeName) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'favoriteePlaces': FieldValue.arrayRemove([placeName]),
      });
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  Future<void> addToVisited(String userId, String placeName) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'visitedPlaces': FieldValue.arrayUnion([placeName]),
      });
    } catch (e) {
      throw Exception('Error adding to visited: $e');
    }
  }

  Future<void> removeFromVisited(String userId, String placeName) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'visitedPlaces': FieldValue.arrayRemove([placeName]),
      });
    } catch (e) {
      throw Exception('Error removing from visited: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UserModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error getting all users: $e');
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(usersCollection)
          .orderBy('name')
          .get();

      List<UserModel> users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UserModel.fromMap(data);
      }).toList();

      return users
          .where(
            (user) =>
                user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Error searching users: $e');
    }
  }

  Future<bool> userExists(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Error checking user existence: $e');
    }
  }

  Future<Map<String, int>> getUsersStats() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(usersCollection)
          .get();

      int totalUsers = snapshot.docs.length;
      int activeUsers = 0;
      DateTime now = DateTime.now();
      DateTime lastWeek = now.subtract(Duration(days: 7));

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime createdAt = data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now();

        if (createdAt.isAfter(lastWeek)) {
          activeUsers++;
        }
      }

      return {
        'total': totalUsers,
        'active': activeUsers,
        'new_this_week': activeUsers,
      };
    } catch (e) {
      throw Exception('Error getting users stats: $e');
    }
  }
}
