import 'package:chatterbox/chatterbox.dart';
import 'package:example/flows/twentyone_sticks_game/twentyone_sticks_bot_game.dart';
import 'package:example/flows/twentyone_sticks_game/twentyone_sticks_pvp_game.dart';

const _trigger = '@TIDSphereBot 21sticks';
const _paramPvp = 'pvp';

/// In the game of 21 Sticks, two players take turns removing 1 to 3 sticks from a total of 21. The player forced to take the last stick loses.
class TwentyOneSticksGameFlow extends Flow {
  static final flows = <Flow>[
    TwentyOneSticksGameFlow(),
    TwentyOneSticksBotGameFlow(),
    TwentyOneSticksPvpGameFlow(),
  ];

  @override
  bool willHandle(MessageContext messageContext) => messageContext.text?.contains('@TIDSphereBot 21sticks') == true;

  @override
  List<StepFactory> get steps => [
        () => TwentyOneSticksGameFlowInitialStep(),
        () => _WaitingSecondPlayerToJoin(),
      ];
}

class TwentyOneSticksGameFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final isPvp = messageContext.text?.replaceAll(_trigger, '').trim() == _paramPvp;

    if (isPvp) {
      return ReactionComposed(responses: [
        ReactionResponse(
          text:
              "You are up for a battle with another player. Please wait for another player to join the game.\n\n To join the game please send command /join",
          afterReplyUri: (_WaitingSecondPlayerToJoin).toStepUri([messageContext.userId.toString()]),
        ),
      ]);
    } else {
      return ReactionComposed(responses: [
        ReactionResponse(
          text: "You are up for a battle with bot. Brace yourself!",
        ),
        ReactionRedirect(
          stepUri: (TwentyOneSticksBotGameFlowInitialStep).toStepUri(
            [messageContext.userId.toString()],
          ),
        ),
      ]);
    }
  }
}

class _WaitingSecondPlayerToJoin extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final firstPlayerId = args?.firstOrNull;
    if (firstPlayerId == null) {
      return ReactionNone();
    }

    if (messageContext.text?.contains('/join') == true) {
      return ReactionComposed(responses: [
        ReactionResponse(
          text: "${messageContext.username ?? 'Brave lad'} responds to your challenge! Game starts now!",
        ),
        ReactionRedirect(
          stepUri: (TwentyOneSticksGamePvpFlowInitialStep).toStepUri([
            firstPlayerId,
            messageContext.userId.toString(),
          ]),
        ),
      ]);
    } else {
      return ReactionComposed(responses: [
        ReactionRedirect(
          stepUri: (TwentyOneSticksBotGameFlowInitialStep).toStepUri(
            [firstPlayerId],
          ),
        ),
      ]);
    }
  }
}
