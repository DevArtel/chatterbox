import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/storage/dialog_store.dart';

class BotRunner {
  final String botToken;
  final List<Flow> flows;
  final PendingMessagesStore store;

  const BotRunner({
    required this.botToken,
    required this.flows,
    required this.store,
  });
}
