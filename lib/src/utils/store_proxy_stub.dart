import 'package:chatterbox/chatterbox.dart';

/// Use it for development or of you running a server on a permanent server
/// When you restart the server all data will be gone
class InMemoryStore extends PendingMessagesStore {
  const InMemoryStore() : super();

  final map = const <int, String>{};

  @override
  Future<void> clearPending(int userId) async {
    map.remove(userId);
  }

  @override
  Future<String?> retrievePending(int userId) async {
    return map[userId];
  }

  @override
  Future<void> setPending(int userId, String stepUrl) async {
    map[userId] = stepUrl;
  }
}
