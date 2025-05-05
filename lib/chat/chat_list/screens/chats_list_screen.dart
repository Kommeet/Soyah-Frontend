import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sohyah/chat/presentation/widgets/app_bar.dart';
import '../data/sample_data.dart';
import '../models/chat.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['All Chats', 'Chat Requests'];
  final List<Chat> _chats = sampleChats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(),
      
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return _buildChatListItem(chat);
              },
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Colors.red
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChatListItem(Chat chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chat: chat),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            chat.avatar.isNotEmpty
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(chat.avatar),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      chat.name.isNotEmpty ? chat.name[0] : '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(width: 12),
            // Chat details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Online indicator
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Chat name
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Last message
                  Text(
                    chat.isTyping ? 'Typing...' : (chat.lastMessage ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Right side (time and unread indicator)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Time
                Text(
                  _formatTime(chat.lastMessageTime ?? DateTime.now()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                // Unread indicator
                if (chat.hasUnreadMessages)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  

  

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inHours < 12) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('H:mm').format(time);
    }
  }
}