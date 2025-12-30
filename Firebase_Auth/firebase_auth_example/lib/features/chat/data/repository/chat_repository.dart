import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/core/errors/failures.dart';
import 'package:firebase_auth_example/core/firebase_keywords/chat_database_keywords.dart';
import 'package:firebase_auth_example/features/chat/data/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _fireStore;


  ChatRepository({FirebaseFirestore? fireStore, FirebaseAuth? firebaseAuth})
    : _fireStore = fireStore ?? FirebaseFirestore.instance;
  
  Stream<List<MessageModel>> getMessages(String chatRoomId){
    return _fireStore
        .collection(FirebaseKeyWords.userRooms)
        .doc(chatRoomId)
        .collection(FirebaseKeyWords.messages)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot){
          return snapshot.docs.map((docs)=> MessageModel.fromMap(docs.data())).toList();
    });
  }

  Future<void> sendMessage(String chatRoomId, MessageModel message) async {
    try {
      await _fireStore
          .collection(FirebaseKeyWords.userRooms)
          .doc(chatRoomId)
          .collection(FirebaseKeyWords.messages)
          .add(message.toMap());

      await _fireStore
          .collection(FirebaseKeyWords.userRooms)
          .doc(chatRoomId)
          .set({
            'lastMessage': message.message,
            'lastMessageTime': message.timestamp,
            'participants': [message.senderId, message.receiverId],
          }, SetOptions(merge: true));
    } catch (e) {
      throw ServerFailure();
    }
  }

  String getChatRoomId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join("_");
  }
}
