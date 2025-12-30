import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_example/features/chat_list/data/chatList_repository.dart';

import 'chatList_event.dart';
import 'chatList_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState>{
  final ChatListRepository chatListRepository;
  ChatListBloc({required this.chatListRepository}) : super(ChatListInitial()){
    on<SearchUserEvent>((event, emit)async {
      emit(SearchListLoading());
      try{
        final users = await chatListRepository.searchQuery(event.query);
        emit(SearchListLoaded(users: users));
      }catch(e){
        emit(ChatListError(error: e.toString()));
      }
    });
    Future<Map<String,dynamic>?> getUserInfoById(String userId) async{
      return await chatListRepository.getUserInfoById(userId);
    }
  }

  Future<Map<String,dynamic>?> getUserInfoById(String userId) async{
    return await chatListRepository.getUserInfoById(userId);
  }

  Stream<QuerySnapshot> getChatRooms(){
    return chatListRepository.getChatRooms();
  }

}