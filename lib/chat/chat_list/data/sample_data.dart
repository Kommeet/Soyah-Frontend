import '../models/chat.dart';
import '../models/message.dart';

// Sample chats for the chat list
final List<Chat> sampleChats = [
  Chat(
    id: '1',
    name: 'Halo Cafe',
    messages: sampleHaloCafeMessages,
    hasUnreadMessages: true,
    lastMessage: 'I love hiking! What about you?',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Chat(
    id: '2',
    name: 'Le Restaurant',
    messages: [],
    hasUnreadMessages: false,
    lastMessage: 'Hope to get to know each other better!',
    avatar: 'assets/images/le_restaurant.jpg',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Chat(
    id: '3',
    name: 'Reika Cafe',
    messages: [],
    hasUnreadMessages: true,
    lastMessage: 'Hey there!',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Chat(
    id: '4',
    name: 'Felicita Cafe',
    messages: [],
    hasUnreadMessages: true,
    isTyping: true,
    lastMessage: 'Typing...',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Chat(
    id: '5',
    name: 'Heavenly Donuts',
    messages: [],
    hasUnreadMessages: false,
    lastMessage: 'Ok, see you then.',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 9)),
  ),
];

// Sample messages for the Halo Cafe chat
final List<Message> sampleHaloCafeMessages = [
  Message(
    id: '1',
    text: "Hi, how are you? I saw on the app that we've crossed paths several times this week 😊",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Message(
    id: '2',
    text: "Hey, I'm doing great!",
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
  ),
  Message(
    id: '3',
    text: "Ohh haha yeah I have seen you as well",
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
  Message(
    id: '4',
    text: "That's nice!",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
  ),
  Message(
    id: '5',
    text: "So what are you doing?",
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
  ),
  Message(
    id: '6',
    text: "Nothing really. Was just browsing on ig",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Message(
    id: '7',
    text: "What are your interests?",
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  Message(
    id: '8',
    text: "I love hiking! What about you?",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
];

// Empty chat for testing the empty state
final Chat emptyChat = Chat(
  id: '6',
  name: 'Halo Cafe',
  messages: [],
);