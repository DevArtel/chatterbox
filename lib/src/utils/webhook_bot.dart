import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

/// A Bot subclass for webhook mode that bypasses the _isRunning check.
/// In Televerse v3, handleUpdate() silently returns if _isRunning is false.
/// For webhook mode (where Cloud Run handles HTTP), we need update processing
/// without starting the long polling or webhook server.
class WebhookBot extends Bot {
  WebhookBot(super.token);

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    await initialize();
  }

  /// Process a webhook update by creating a context and passing it through
  /// the middleware chain directly, bypassing the _isRunning check.
  Future<void> processWebhookUpdate(Update update) async {
    await _ensureInitialized();
    final ctx = Context(update, api, botInfo);
    await handle(ctx);
  }
}
