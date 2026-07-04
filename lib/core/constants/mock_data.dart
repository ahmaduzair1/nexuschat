/// Nexus Chat — Mock Data
///
/// Realistic sample data for the messaging UI concept.
/// All avatar URLs use the ui-avatars.com API for dynamic avatar generation.

class MockUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String? statusText;

  const MockUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.statusText,
  });
}

class MockMessage {
  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final bool isRead;
  final bool isAI;
  final String? replyTo;
  final List<String>? reactions;

  const MockMessage({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.isRead = false,
    this.isAI = false,
    this.replyTo,
    this.reactions,
  });
}

class MockChat {
  final String id;
  final MockUser user;
  final List<MockMessage> messages;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final bool isTyping;

  const MockChat({
    required this.id,
    required this.user,
    required this.messages,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    this.isTyping = false,
  });

  MockMessage get lastMessage => messages.last;
}

class MockStatus {
  final MockUser user;
  final int totalSegments;
  final int viewedSegments;
  final DateTime timestamp;

  const MockStatus({
    required this.user,
    required this.totalSegments,
    this.viewedSegments = 0,
    required this.timestamp,
  });
}

// ── Helper ──
String _avatarUrl(String name, {String bg = '00C896', String color = '0A0E1A'}) {
  final encoded = Uri.encodeComponent(name);
  return 'https://ui-avatars.com/api/?name=$encoded&background=$bg&color=$color&size=128&bold=true&format=png';
}

// ── Users ──
final List<MockUser> mockUsers = [
  MockUser(
    id: 'u1',
    name: 'Sarah Chen',
    avatarUrl: _avatarUrl('Sarah Chen'),
    isOnline: true,
    statusText: 'Building the future ✨',
  ),
  MockUser(
    id: 'u2',
    name: 'Marcus Rivera',
    avatarUrl: _avatarUrl('Marcus Rivera', bg: 'FFD700', color: '0A0E1A'),
    isOnline: true,
    statusText: 'In a meeting',
  ),
  MockUser(
    id: 'u3',
    name: 'Yuki Tanaka',
    avatarUrl: _avatarUrl('Yuki Tanaka', bg: '448AFF', color: 'FFFFFF'),
    isOnline: false,
    statusText: 'Away',
  ),
  MockUser(
    id: 'u4',
    name: 'Amara Okafor',
    avatarUrl: _avatarUrl('Amara Okafor', bg: 'FF4B6E', color: 'FFFFFF'),
    isOnline: true,
  ),
  MockUser(
    id: 'u5',
    name: 'Liam O\'Brien',
    avatarUrl: _avatarUrl('Liam O Brien', bg: '69F0AE', color: '0A0E1A'),
    isOnline: false,
  ),
  MockUser(
    id: 'u6',
    name: 'Priya Sharma',
    avatarUrl: _avatarUrl('Priya Sharma', bg: 'C9A84C', color: '0A0E1A'),
    isOnline: true,
    statusText: 'Available',
  ),
  MockUser(
    id: 'u7',
    name: 'Nexus AI',
    avatarUrl: _avatarUrl('AI', bg: '00FFB2', color: '0A0E1A'),
    isOnline: true,
    statusText: 'Always here to help',
  ),
  MockUser(
    id: 'u8',
    name: 'Design Team',
    avatarUrl: _avatarUrl('Design Team', bg: '7C4DFF', color: 'FFFFFF'),
    isOnline: false,
  ),
  MockUser(
    id: 'u9',
    name: 'Elena Volkov',
    avatarUrl: _avatarUrl('Elena Volkov', bg: 'FF6E40', color: 'FFFFFF'),
    isOnline: false,
    statusText: 'On vacation 🌴',
  ),
  MockUser(
    id: 'u10',
    name: 'James Park',
    avatarUrl: _avatarUrl('James Park', bg: '26C6DA', color: '0A0E1A'),
    isOnline: true,
  ),
];

// ── Chat Conversations ──
final DateTime _now = DateTime.now();

final List<MockChat> mockChats = [
  MockChat(
    id: 'c1',
    user: mockUsers[0], // Sarah Chen
    isPinned: true,
    unreadCount: 3,
    messages: [
      MockMessage(
        id: 'm1',
        text: 'Hey! Have you seen the new design specs?',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 45)),
      ),
      MockMessage(
        id: 'm2',
        text: 'Yes! The glassmorphism looks incredible 🔥',
        isSent: true,
        timestamp: _now.subtract(const Duration(minutes: 42)),
        isRead: true,
      ),
      MockMessage(
        id: 'm3',
        text: 'I think we should push the emerald gradient even further',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 38)),
      ),
      MockMessage(
        id: 'm4',
        text: 'Totally agree. What about adding a subtle gold accent for premium features?',
        isSent: true,
        timestamp: _now.subtract(const Duration(minutes: 35)),
        isRead: true,
      ),
      MockMessage(
        id: 'm5',
        text: 'Love that idea! Let me mock it up real quick',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 30)),
      ),
      MockMessage(
        id: 'm6',
        text: 'Check this out — the new component library is ready for review',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 5)),
      ),
      MockMessage(
        id: 'm7',
        text: 'The motion system is chef\'s kiss 🤌',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 2)),
      ),
    ],
  ),
  MockChat(
    id: 'c2',
    user: mockUsers[6], // Nexus AI
    isPinned: true,
    messages: [
      MockMessage(
        id: 'ai1',
        text: 'Good morning! I\'ve analyzed your schedule for today. You have 3 meetings and 2 pending tasks.',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 2)),
        isAI: true,
      ),
      MockMessage(
        id: 'ai2',
        text: 'Summarize my unread messages',
        isSent: true,
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 55)),
        isRead: true,
      ),
      MockMessage(
        id: 'ai3',
        text: 'Here\'s your summary:\n\n• Sarah shared new design specs (high priority)\n• Design Team discussed the Q2 roadmap\n• Marcus needs feedback on the API integration\n\nWould you like me to draft replies?',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 54)),
        isAI: true,
      ),
    ],
  ),
  MockChat(
    id: 'c3',
    user: mockUsers[1], // Marcus Rivera
    unreadCount: 1,
    isTyping: true,
    messages: [
      MockMessage(
        id: 'mr1',
        text: 'The API integration is almost done',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 1)),
      ),
      MockMessage(
        id: 'mr2',
        text: 'Nice work! Any blockers?',
        isSent: true,
        timestamp: _now.subtract(const Duration(minutes: 55)),
        isRead: true,
      ),
      MockMessage(
        id: 'mr3',
        text: 'Just the authentication flow — need your input on the token refresh strategy',
        isSent: false,
        timestamp: _now.subtract(const Duration(minutes: 50)),
      ),
    ],
  ),
  MockChat(
    id: 'c4',
    user: mockUsers[7], // Design Team
    unreadCount: 12,
    messages: [
      MockMessage(
        id: 'dt1',
        text: 'Q2 roadmap finalized! Check the shared doc 📋',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 3)),
      ),
      MockMessage(
        id: 'dt2',
        text: 'Great work everyone! The new design system is looking sharp',
        isSent: true,
        timestamp: _now.subtract(const Duration(hours: 2, minutes: 45)),
        isRead: true,
      ),
      MockMessage(
        id: 'dt3',
        text: 'Meeting at 3 PM to discuss implementation timeline',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
    ],
  ),
  MockChat(
    id: 'c5',
    user: mockUsers[3], // Amara Okafor
    messages: [
      MockMessage(
        id: 'ao1',
        text: 'The performance benchmarks look amazing! 60fps across the board 🎯',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 4)),
      ),
      MockMessage(
        id: 'ao2',
        text: 'Thanks! The lazy loading made a huge difference',
        isSent: true,
        timestamp: _now.subtract(const Duration(hours: 3, minutes: 50)),
        isRead: true,
      ),
    ],
  ),
  MockChat(
    id: 'c6',
    user: mockUsers[4], // Liam O'Brien
    messages: [
      MockMessage(
        id: 'lo1',
        text: 'Can you review my PR? It\'s the new animation system',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 6)),
      ),
      MockMessage(
        id: 'lo2',
        text: 'Sure! I\'ll check it this afternoon',
        isSent: true,
        timestamp: _now.subtract(const Duration(hours: 5, minutes: 30)),
        isRead: true,
      ),
    ],
  ),
  MockChat(
    id: 'c7',
    user: mockUsers[5], // Priya Sharma
    unreadCount: 2,
    messages: [
      MockMessage(
        id: 'ps1',
        text: 'The new chat bubble animations are so smooth!',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 8)),
      ),
      MockMessage(
        id: 'ps2',
        text: 'Right? The spring physics make it feel so premium',
        isSent: true,
        timestamp: _now.subtract(const Duration(hours: 7, minutes: 45)),
        isRead: true,
      ),
      MockMessage(
        id: 'ps3',
        text: 'I added micro-bounce to the reaction wheel too',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 7, minutes: 30)),
      ),
      MockMessage(
        id: 'ps4',
        text: 'Have you tested the swipe gestures on the chat list?',
        isSent: false,
        timestamp: _now.subtract(const Duration(hours: 7)),
      ),
    ],
  ),
  MockChat(
    id: 'c8',
    user: mockUsers[8], // Elena Volkov
    isMuted: true,
    messages: [
      MockMessage(
        id: 'ev1',
        text: 'Hey! Just landed in Bali 🌴 The wifi here is surprisingly good',
        isSent: false,
        timestamp: _now.subtract(const Duration(days: 1)),
      ),
      MockMessage(
        id: 'ev2',
        text: 'Jealous! Enjoy your vacation 🎉',
        isSent: true,
        timestamp: _now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ],
  ),
  MockChat(
    id: 'c9',
    user: mockUsers[9], // James Park
    messages: [
      MockMessage(
        id: 'jp1',
        text: 'The dark mode implementation looks flawless',
        isSent: false,
        timestamp: _now.subtract(const Duration(days: 1, hours: 3)),
      ),
      MockMessage(
        id: 'jp2',
        text: 'Thanks! The emerald on navy combo hits different at night',
        isSent: true,
        timestamp: _now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
      ),
    ],
  ),
  MockChat(
    id: 'c10',
    user: mockUsers[2], // Yuki Tanaka
    messages: [
      MockMessage(
        id: 'yt1',
        text: 'The typography system is perfect — Inter was the right call',
        isSent: false,
        timestamp: _now.subtract(const Duration(days: 2)),
      ),
      MockMessage(
        id: 'yt2',
        text: 'Agreed! The tight heading spacing with dense body text works great for chat',
        isSent: true,
        timestamp: _now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ],
  ),
];

// ── Status / Stories ──
final List<MockStatus> mockStatuses = [
  MockStatus(
    user: mockUsers[0],
    totalSegments: 3,
    viewedSegments: 1,
    timestamp: _now.subtract(const Duration(hours: 1)),
  ),
  MockStatus(
    user: mockUsers[1],
    totalSegments: 5,
    viewedSegments: 5,
    timestamp: _now.subtract(const Duration(hours: 2)),
  ),
  MockStatus(
    user: mockUsers[3],
    totalSegments: 2,
    viewedSegments: 0,
    timestamp: _now.subtract(const Duration(hours: 3)),
  ),
  MockStatus(
    user: mockUsers[5],
    totalSegments: 4,
    viewedSegments: 2,
    timestamp: _now.subtract(const Duration(hours: 5)),
  ),
  MockStatus(
    user: mockUsers[8],
    totalSegments: 7,
    viewedSegments: 0,
    timestamp: _now.subtract(const Duration(hours: 6)),
  ),
  MockStatus(
    user: mockUsers[9],
    totalSegments: 1,
    viewedSegments: 0,
    timestamp: _now.subtract(const Duration(hours: 8)),
  ),
];

// ── Smart Reply Suggestions ──
const List<String> mockSmartReplies = [
  'Sounds great! 👍',
  'Let me check and get back to you',
  'On it!',
  'Thanks for letting me know',
  'Can we discuss this tomorrow?',
];

// ── Time Formatting ──
String formatTimestamp(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min $amPm';
  }
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[time.weekday - 1];
  }
  return '${time.month}/${time.day}';
}

String formatMessageTime(DateTime time) {
  final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
  final amPm = time.hour >= 12 ? 'PM' : 'AM';
  final min = time.minute.toString().padLeft(2, '0');
  return '$hour:$min $amPm';
}
