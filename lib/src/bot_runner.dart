import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/storage/dialog_store.dart';
import 'package:chatterbox/src/utils/store_proxy_stub.dart';

class BotRunner {
  final String botToken;
  final List<Flow> flows;
  final PendingMessagesStore store;

  const BotRunner({
    required this.botToken,
    required this.flows,
    this.store = const InMemoryStore(),
  });
}
