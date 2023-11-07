/// Storage to keep information on pending messages
abstract class PendingMessagesStore {
  const PendingMessagesStore();

  Future<String?> retrievePending(int userId);

  Future<void> setPending(int userId, String stepUrl);

  Future<void> clearPending(int userId);
}
