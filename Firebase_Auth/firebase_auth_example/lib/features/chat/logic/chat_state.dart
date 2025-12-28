import 'package:equatable/equatable.dart';

import '../data/models/message_model.dart';

class ChatState extends Equatable{
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  const ChatLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];

}

class ChatError extends ChatState{
  final String error;
  const ChatError({required this.error});

  @override
  List<Object?> get props => [error];
}
