/// Storage to keep information on pending messages
abstract class PendingMessagesStore {
  const PendingMessagesStore();

  Future<String?> retrievePending(int userId, int chatId);

  Future<void> setPending(int userId, int chatId, String stepUrl);

  Future<void> clearPending(int userId, int chatId);
}
