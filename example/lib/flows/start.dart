import 'package:chatterbox/chatterbox.dart';
import 'package:example/flows/menu.dart';

class StartFlow extends CommandFlow {
  @override
  String get command => 'start'; //todo if you declare command as '/start' you are fucked, fix in the package

  @override
  List<StepFactory> get steps => [
        () => _InitialStep(),
      ];
}

class _InitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionComposed(
      responses: [
        ReactionResponse(
          text: "Heheheh! Woody here! 🐦 Ready to chat and chuckle! What's up?",
        ),
        ReactionRedirect(stepUri: (MenuInitialStep).toStepUri())
      ],
    );
  }
}
