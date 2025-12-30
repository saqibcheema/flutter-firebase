import 'package:equatable/equatable.dart';

class ChatListState extends Equatable{
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}
class ChatListLoading extends ChatListState {}
class SearchListLoading extends ChatListState {}
class SearchListLoaded extends ChatListState{
  final List<Map<String,dynamic>> users;
  const SearchListLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}
class ChatListLoaded extends ChatListState{
  final List<Map<String,dynamic>> chatRooms;
  const ChatListLoaded({required this.chatRooms});

  @override
  List<Object?> get props => [chatRooms];
}

class ChatListError extends ChatListState{
  final String error;
  const ChatListError({required this.error});

  @override
  List<Object?> get props => [error];
}
