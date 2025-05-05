import 'message.dart';

class Chat {
  final String id;
  final String name;
  final List<Message> messages;
  final bool hasUnreadMessages;
  final String? lastMessage;
  final String avatar;
  final bool isTyping;
  final DateTime? lastMessageTime;

  Chat({
    required this.id,
    required this.name,
    required this.messages,
    this.hasUnreadMessages = false,
    this.lastMessage,
    this.avatar = '',
    this.isTyping = false,
    this.lastMessageTime,
  });
}