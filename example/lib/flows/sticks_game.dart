import 'dart:math';

import 'package:chatterbox/chatterbox.dart';

/// In the game of 21 Sticks, two players take turns removing 1 to 3 sticks from a total of 21. The player forced to take the last stick loses.
class TwentyOneSticksGameFlow extends Flow {
  @override
  List<StepFactory> get steps => [
        () => TwentyOneSticksGameFlowInitialStep(),
        () => _PlayerTurnStep(),
        () => _BotTurnStep(),
      ];
}

class TwentyOneSticksGameFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionComposed(responses: [
      ReactionResponse(
        text:
            "In the game of 21 Sticks, two players take turns removing 1 to 3 sticks from a total of 21. The player forced to take the last stick loses.",
      ),
      ReactionRedirect(stepUri: (_PlayerTurnStep).toStepUri())
    ]);
  }
}

class _PlayerTurnStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final number = (args?.firstOrNull ?? '21');

    return ReactionResponse(
        text: 'There are $number sticks.\n\nHow many sticks do you want to take?',
        // editMessageId: messageContext.editMessageId,
        buttons: [
          InlineButton(title: 'One', nextStepUri: (_BotTurnStep).toStepUri([number, '1'])),
          InlineButton(title: 'Two', nextStepUri: (_BotTurnStep).toStepUri([number, '2'])),
          InlineButton(title: 'Three', nextStepUri: (_BotTurnStep).toStepUri([number, '3'])),
        ]);
  }
}

class _BotTurnStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final originalNumber = (args?.firstOrNull ?? '21');
    final userChoice = (args?.elementAtOrNull(1) ?? '1');

    final number = int.parse(originalNumber) - int.parse(userChoice);

    final botTurn = Random().nextInt(3) + 1;

    return ReactionComposed(responses: [
      ReactionResponse(
        text: 'There are $originalNumber sticks.\n\nYou took out #$userChoice sticks.',
        editMessageId: messageContext.editMessageId,
      ),
      ReactionResponse(
        text: 'There are $number sticks.\n\nBot takes out $botTurn sticks.',
      ),
      ReactionRedirect(
        stepUri: (_PlayerTurnStep).toStepUri().appendArgs(['${number - botTurn}']),
      ),
    ]);
  }
}
