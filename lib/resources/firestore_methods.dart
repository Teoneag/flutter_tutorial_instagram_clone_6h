import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '/resources/storage_methdods.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // upload post
  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      if (description.isNotEmpty && file.isNotEmpty && uid.isNotEmpty) {
        String photoUrl = await StorageMethds().uploadImageToStorage(
          'posts',
          file,
          true,
        );

        String postId = const Uuid().v1();

        Post post = Post(
          datePublished: DateTime.now(),
          description: description,
          likes: [],
          postId: postId,
          postUrl: photoUrl,
          profImageUrl: profImage,
          uid: uid,
          username: username,
        );

        User? _user = _auth.currentUser;
        await _firestore.collection('posts').doc(postId).set(post.toJson());
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print('$e');
    }
  }
}
