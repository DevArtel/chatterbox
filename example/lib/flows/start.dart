import 'package:chatterbox/chatterbox.dart';

class StartFlow extends CommandFlow {
  @override
  String get command => 'start'; //todo if you declare command as '/start' you are fucked, fix in the package

  @override
  List<StepFactory> get steps => [
        () => _InitialFlow(),
      ];
}

class _InitialFlow extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(text: "Heheheh! Woody here! 🐦 Ready to chat and chuckle! What's up?");
  }
}
