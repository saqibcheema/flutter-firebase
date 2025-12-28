import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failures.dart';
import '../../../core/firebase_keywords/chat_database_keywords.dart';

class ChatListRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;

  ChatListRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? fireStore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _fireStore = fireStore ?? FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchQuery(String query) async {
    final lowerCaseQuery = query.toLowerCase();

    try {
      final snapshot = await _fireStore
          .collection(FirebaseKeyWords.users)
          .where(
            FirebaseKeyWords.searchUsers,
            isGreaterThanOrEqualTo: lowerCaseQuery,
          )
          .where(
            FirebaseKeyWords.searchUsers,
            isLessThan: '$lowerCaseQuery \uf8ff',
          )
          .get();

      final currentUid = _firebaseAuth.currentUser;

      return snapshot.docs
          .map((e) => e.data())
          .where((data) => data['uid'] != currentUid?.uid)
          .toList();
    } catch (e) {
      throw ServerFailure();
    }
  }
}
