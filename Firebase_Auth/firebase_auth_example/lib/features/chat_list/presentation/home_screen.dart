import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Navigation k liye

import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_events.dart';
import '../../chat/data/repository/chat_repository.dart';
import '../logic/bloc/chatlist/chatList_event.dart';
import '../logic/bloc/chatlist/chatList_state.dart';
import '../logic/bloc/chatlist/chatlist_bloc.dart';
import 'chatlist_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatRepository _chatRepo = ChatRepository();
  bool _isSearching = false;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;


  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: (){
            context.read<AuthBloc>().add(AuthSignOut());
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _isSearching = false);
                    })
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) {
                setState(() {
                  _isSearching = val.isNotEmpty;
                });
                if (val.isNotEmpty) {
                  context.read<ChatListBloc>().add(SearchUserEvent(query: val));
                }
              },
            ),
          ),

          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildRecentChats(),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchResults() {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is SearchListLoading) return const Center(child: CircularProgressIndicator());

        if (state is SearchListLoaded) {
          if (state.users.isEmpty) return const Center(child: Text("No user found"));

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final userMap = state.users[index];
              final name = userMap['displayName'] ?? userMap['username'] ?? 'Unknown';
              final image = userMap['profilePhoto'] ?? userMap['profilePic'] ?? '';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                  child: image.isEmpty ? Icon(Icons.person, color: Colors.white) : null,
                ),
                title: Text(name),
                subtitle: Text(userMap['email'] ?? ''),
                onTap: () {
                  final otherUserId = userMap['uid'];
                  final roomId = getChatRoomId(currentUserId, otherUserId);

                  context.push(Routes.chatScreen, extra: {
                    'roomId': roomId,
                    'receiverId': otherUserId,
                    'receiverName': name,
                    'receiverProfilePic': image,
                  });
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }


  Widget _buildRecentChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<ChatListBloc>().getChatRooms(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text("No conversations yet"),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            List participants = data['participants'];
            String otherUserId = participants.firstWhere((id) => id != currentUserId, orElse: () => '');

            if(otherUserId.isEmpty) return SizedBox.shrink();

            DateTime time = DateTime.now();
            if (data['lastMessageTime'] != null) {
              time = (data['lastMessageTime'] as Timestamp).toDate();
            }


            return ChatListTile(
              roomId: doc.id,
              lastMessage: data['lastMessage'] ?? '',
              time: time,
              otherUserId: otherUserId,
            );
          },
        );
      },
    );
  }
}