import 'package:firebase_auth_example/features/chat/data/models/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {

    on<GetMessageEvent>((event, emit) async {
      emit(ChatLoading());

      await emit.forEach(
        chatRepository.getMessages(event.chatRoomId),
        onData: (messages) => ChatLoaded(messages: messages),
        onError: (error, stackTrace) => ChatError(error: error.toString()),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      try{
        final newMessage = MessageModel(
          senderId: event.senderId,
          receiverId: event.receiverId,
          message: event.message,
          timestamp: DateTime.now(),
        );

        await chatRepository.sendMessage(event.chatRoomId, newMessage);
      }catch(e){
        emit(ChatError(error: e.toString()));
      }
    });
  }
}
