import 'package:chatterbox/chatterbox.dart';

/// Use it for development or of you running a server on a permanent server
/// When you restart the server all data will be gone
class InMemoryStore implements PendingMessagesStore {
  InMemoryStore() : super();

  final map = <String, String>{};

  @override
  Future<void> clearPending(int userId, int chatId) async {
    map.remove('$chatId-$userId');
  }

  @override
  Future<String?> retrievePending(int userId, int chatId) async {
    return map['$chatId-$userId'];
  }

  @override
  Future<void> setPending(int userId, int chatId, String stepUrl) async {
    map['$chatId-$userId'] = stepUrl;
  }
}
