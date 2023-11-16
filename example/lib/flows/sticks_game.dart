import 'package:chatterbox/chatterbox.dart';

class SticksGameFlow extends Flow {
  @override
  List<StepFactory> get steps => [
        () => SticksGameFlowInitialStep(),
      ];
}

class SticksGameFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(text: "Not implemented");
  }
}
