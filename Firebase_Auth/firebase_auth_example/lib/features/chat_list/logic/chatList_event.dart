import 'package:equatable/equatable.dart';

class ChatListEvent extends Equatable{
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}
class SearchUserEvent extends ChatListEvent{
  final String query;
  const SearchUserEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GetChatRoomsEvent extends ChatListEvent{
  final String uid;
  const GetChatRoomsEvent({required this.uid});
  @override
  List<Object?> get props => [uid];
}
