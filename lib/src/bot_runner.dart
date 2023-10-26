import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/storage/dialog_store.dart';

class BotRunner {
  final String botToken;
  final ChatterboxStore dialogDao;
  final List<Flow> flows;

  BotRunner({
    required this.botToken,
    required this.dialogDao,
    required this.flows,
  });
}
