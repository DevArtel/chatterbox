import 'dart:math';

import 'package:chatterbox/chatterbox.dart';

enum _Player { user, bot }

extension _PlayerExtension on _Player {
  _Player get getOpponent => switch (this) {
        _Player.user => _Player.bot,
        _Player.bot => _Player.user,
      };
}

/// In the game of 21 Sticks, two players take turns removing 1 to 3 sticks from a total of 21. The player forced to take the last stick loses.
class TwentyOneSticksGameFlow extends Flow {
  @override
  List<StepFactory> get steps => [
        () => GameFlowInitialStep(),
        () => _UserInputStep(),
        () => _BotTurnStep(),
        () => _OnPlayerWonStep(),
        () => _GameProcessingStep(),
        () => _OnPlayerWonStep(),
      ];
}

class GameFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionComposed(responses: [
      ReactionResponse(
        text:
            "In the game of 21 Sticks, two players take turns removing 1 to 3 sticks from a total of 21. The player forced to take the last stick loses.",
      ),
      ReactionRedirect(stepUri: (_UserInputStep).toStepUri())
    ]);
  }
}

class _UserInputStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final number = (args?.firstOrNull ?? '21');

    return ReactionResponse(
        text: 'There are $number sticks.\n\nHow many sticks do you want to take?',
        // editMessageId: messageContext.editMessageId,
        buttons: [
          InlineButton(title: 'One', nextStepUri: (_GameProcessingStep).toStepUri([_Player.user.name, number, '1'])),
          InlineButton(title: 'Two', nextStepUri: (_GameProcessingStep).toStepUri([_Player.user.name, number, '2'])),
          InlineButton(title: 'Three', nextStepUri: (_GameProcessingStep).toStepUri([_Player.user.name, number, '3'])),
        ].sublist(0, min(3, int.parse(number))));
  }
}

class _GameProcessingStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final actor = _Player.values.byName(args!.first);
    final originalNumber = int.parse(args.elementAtOrNull(1)!);
    final playerChoice = int.parse(args.elementAtOrNull(2)!);

    final sticksLeft = originalNumber - playerChoice;

    if (sticksLeft == 1) {
      // actor won
      return ReactionRedirect(stepUri: (_OnPlayerWonStep).toStepUri([actor.name]));
    } else if (sticksLeft == 0) {
      // opponent won
      return ReactionRedirect(stepUri: (_OnPlayerWonStep).toStepUri([actor.getOpponent.name]));
    } else {
      // continue by invoking opponent turn
      return switch (actor) {
        _Player.user => ReactionRedirect(stepUri: (_BotTurnStep).toStepUri(['$sticksLeft'])),
        _Player.bot => ReactionRedirect(stepUri: (_UserInputStep).toStepUri(['$sticksLeft'])),
      };
    }
  }
}

class _BotTurnStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final sticksLeft = int.parse(args!.first);

    final botTurn = Random().nextInt(min(3, sticksLeft)) + 1;

    return ReactionComposed(responses: [
      ReactionResponse(
        text: 'There are $sticksLeft sticks.\n\nBot takes out $botTurn sticks.',
      ),
      ReactionRedirect(
        stepUri: (_GameProcessingStep).toStepUri(['bot', sticksLeft.toString(), botTurn.toString()]),
      ),
    ]);
  }
}

class _OnPlayerWonStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final actor = _Player.values.byName(args!.first);

    return ReactionComposed(responses: [
      ReactionResponse(
        text: '${actor.name} won!',
      ),
    ]);
  }
}
