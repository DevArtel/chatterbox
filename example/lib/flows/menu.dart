import 'package:chatterbox/chatterbox.dart';
import 'package:example/flows/coundown_game.dart';
import 'package:example/flows/sticks_game.dart';

class MenuFlow extends CommandFlow {
  @override
  String get command => 'menu';

  @override
  List<StepFactory> get steps => [
        () => MenuInitialStep(),
      ];
}

class MenuInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(text: "Choose a game you want to play", buttons: [
      InlineButton(
        title: 'Play Countdown',
        nextStepUri: (CountdownGameFlowInitialStep).toStepUri(),
      ),
      InlineButton(
        title: 'Play 21 sticks',
        nextStepUri: (StartStep).toStepUri(),
      ),
    ]);
  }
}
