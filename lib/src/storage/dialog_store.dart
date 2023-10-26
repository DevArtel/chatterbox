abstract class ChatterboxStore {
  Future<String?> retrievePending(int userId);

  Future<void> setPending(int userId, String stepUrl);

  Future<void> clearPending(int userId);
}
