import 'package:chatterbox/chatterbox.dart';

class CountdownGameFlow extends Flow {
  @override
  List<StepFactory> get steps => [
        () => CountdownGameFlowInitialStep(),
        () => _StartCountdownStep(),
        () => _UserResponseStep(),
        () => _GameCompletedStep(),
      ];
}

class CountdownGameFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'How much do you want to count down?',
      buttons: [
        InlineButton(title: '2', nextStepUri: (_StartCountdownStep).toStepUri().appendArgs(['2'])),
        InlineButton(title: '10', nextStepUri: (_StartCountdownStep).toStepUri().appendArgs(['10'])),
        InlineButton(title: '12', nextStepUri: (_StartCountdownStep).toStepUri().appendArgs(['12'])),
      ],
    );
  }
}

class _StartCountdownStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final number = (args?.firstOrNull ?? '100');

    return ReactionResponse(
      text: "Understood, let's start countdown from $number. Your turn, please start",
      afterReplyUri: (_UserResponseStep).toStepUri([number]),
    );
  }
}

class _UserResponseStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final userInput = messageContext.text;
    final number = (args?.firstOrNull ?? '100');

    if (userInput == number) {
      if (number == "0") {
        return ReactionRedirect(stepUri: (_GameCompletedStep).toStepUri());
      } else {
        // bot turn to name a number, so I need to calculate the number, and then wait for user to name a new number
        final newNumber = int.parse(number) - 1;

        return ReactionResponse(
          text: "$newNumber",
          afterReplyUri: (_UserResponseStep).toStepUri().appendArgs(['${newNumber - 1}']),
        );
      }
    } else {
      return ReactionResponse(
        text: "Dude, this is a wrong number, please do again.",
        afterReplyUri: (_UserResponseStep).toStepUri().appendArgs([number]),
      );
    }
  }
}

class _GameCompletedStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(text: "Game completed");
  }
}
