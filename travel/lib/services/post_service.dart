import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String postsCollection = 'posts';

  Future<void> addPost(PostModel post) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(postsCollection)
          .add(post.toMap());

      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Error adding post: $e');
    }
  }

  Stream<List<PostModel>> getAllPosts() {
    return _firestore
        .collection(postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return PostModel.fromMap(data);
          }).toList();
        });
  }

  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection(postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return PostModel.fromMap(data);
          }).toList();
        });
  }

  Future<PostModel?> getPost(String postId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(postsCollection)
          .doc(postId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return PostModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting post: $e');
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      DocumentReference postRef = _firestore
          .collection(postsCollection)
          .doc(postId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (postSnapshot.exists) {
          Map<String, dynamic> data =
              postSnapshot.data() as Map<String, dynamic>;
          List<String> likes = List<String>.from(data['likes'] ?? []);

          if (likes.contains(userId)) {
            likes.remove(userId);
          } else {
            likes.add(userId);
          }

          transaction.update(postRef, {'likes': likes});
        }
      });
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      DocumentReference postRef = _firestore
          .collection(postsCollection)
          .doc(postId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (postSnapshot.exists) {
          Map<String, dynamic> data =
              postSnapshot.data() as Map<String, dynamic>;
          List<dynamic> comments = data['comments'] ?? [];

          comments.add(comment.toMap());

          transaction.update(postRef, {'comments': comments});
        }
      });
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      DocumentReference postRef = _firestore
          .collection(postsCollection)
          .doc(postId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (postSnapshot.exists) {
          Map<String, dynamic> data =
              postSnapshot.data() as Map<String, dynamic>;
          List<dynamic> comments = data['comments'] ?? [];

          comments.removeWhere((comment) => comment['id'] == commentId);

          transaction.update(postRef, {'comments': comments});
        }
      });
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(postsCollection).doc(postId).update(updates);
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  Future<void> deletePost(String postId, String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(postsCollection)
          .doc(postId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['userId'] == userId) {
          await _firestore.collection(postsCollection).doc(postId).delete();
        } else {
          throw Exception('Unauthorized: Cannot delete post');
        }
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }

  Stream<List<PostModel>> searchPosts(String query) {
    return _firestore
        .collection(postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                Map<String, dynamic> data = doc.data();
                data['id'] = doc.id;
                return PostModel.fromMap(data);
              })
              .where(
                (post) =>
                    post.placeName.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    post.location.toLowerCase().contains(query.toLowerCase()) ||
                    post.description.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
        });
  }

  Stream<List<PostModel>> getPostsByLocation(String location) {
    return _firestore
        .collection(postsCollection)
        .where('location', isEqualTo: location)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return PostModel.fromMap(data);
          }).toList();
        });
  }

  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      QuerySnapshot postsSnapshot = await _firestore
          .collection(postsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      int totalPosts = postsSnapshot.docs.length;
      int totalLikes = 0;
      int totalComments = 0;

      for (var doc in postsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> likes = List<String>.from(data['likes'] ?? []);
        List<dynamic> comments = data['comments'] ?? [];

        totalLikes += likes.length;
        totalComments += comments.length;
      }

      return {
        'posts': totalPosts,
        'likes': totalLikes,
        'comments': totalComments,
      };
    } catch (e) {
      throw Exception('Error getting user stats: $e');
    }
  }
}
