import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routes.dart';
import '../logic/bloc/chatlist/chatlist_bloc.dart';

class ChatListTile extends StatelessWidget {
  final String roomId;
  final String lastMessage;
  final DateTime time;
  final String otherUserId;

  const ChatListTile({
    super.key,
    required this.roomId,
    required this.lastMessage,
    required this.time,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: context.read<ChatListBloc>().getUserInfoById(otherUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey),
            title: Text("Loading..."),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;

          final name = data['displayName'] ?? 'Unknown User';
          final image = data['profilePhoto'] ?? '';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
              child: image.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              context.push(Routes.chatScreen, extra: {
                'roomId': roomId,
                'receiverId': otherUserId,
                'receiverName': name,
                'receiverProfilePic': image,
              });
            },
          );
        }
        return const SizedBox.shrink();
      },
    );



  }
}