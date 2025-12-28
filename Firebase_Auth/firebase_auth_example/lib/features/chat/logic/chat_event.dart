import 'package:equatable/equatable.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetMessageEvent extends ChatEvent {
  final String chatRoomId;
  const GetMessageEvent({required this.chatRoomId});

  @override
  List<Object?> get props => [chatRoomId];
}

class SendMessageEvent extends ChatEvent {
  final String chatRoomId;
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  const SendMessageEvent({
    required this.chatRoomId,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp
  });

  @override
  List<Object?> get props => [chatRoomId, message, senderId, receiverId];
}
