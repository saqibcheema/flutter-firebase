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
    final searchTerm = query.toLowerCase().trim();

    try {
      final snapshot = await _fireStore
          .collection(FirebaseKeyWords.users)
          .where(
          'searchKeywords',
        arrayContains:searchTerm
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

  Future<Map<String,dynamic>?> getUserInfoById(String userId) async{
    try{
      final doc = await _fireStore.collection(FirebaseKeyWords.users).doc(userId).get();
      if(doc.exists){
        return doc.data();
      }
      return null;
    }catch(e){
      throw ServerFailure();
    }
  }

  Stream<QuerySnapshot> getChatRooms() {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return _fireStore
        .collection(FirebaseKeyWords.userRooms)
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}