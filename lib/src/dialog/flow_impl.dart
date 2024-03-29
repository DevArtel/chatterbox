import 'package:chatterbox/src/api/bot_facade.dart';
import 'package:chatterbox/src/dialog/flow.dart';
import 'package:chatterbox/src/dialog/reaction.dart';
import 'package:chatterbox/src/model/message_context.dart';
import 'package:chatterbox/src/storage/dialog_store.dart';
import 'package:collection/collection.dart';

abstract class FlowManager {
  List<FlowStep> get allStepsByUri;

  Future<bool> handle(MessageContext messageContext, [StepUri? stepUri]);
}

typedef StepFactory = FlowStep Function();

class FlowManagerImpl implements FlowManager {
  final BotFacade bot;
  final PendingMessagesStore store;
  final List<Flow> flows;

  FlowManagerImpl(this.bot, this.store, this.flows);

  @override
  List<FlowStep> get allStepsByUri =>
      flows.map((flow) => flow.steps).expand((steps) => steps).map((step) => step()).toList();

  @override
  Future<bool> handle(MessageContext messageContext, [StepUri? stepUri]) async {
    final userId = messageContext.userId;
    final editMessageId = messageContext.editMessageId;

    print("Handle invoked $userId $editMessageId ${messageContext.text}");

    final String? pendingStepUrl = await _processPending(stepUri, userId);
    final pendingData = FlowStep.fromUri(pendingStepUrl, allStepsByUri);
    final pendingStep = pendingData.$1;
    final pendingArgs = pendingData.$2;

    if (pendingStep == null && stepUri == null) {
      final Flow? handlingFlow = flows.firstWhereOrNull((flow) => flow.willHandle(messageContext));
      if (handlingFlow != null) {
        processResult(handlingFlow.initialStep, null, messageContext);
        print("[FlowManager] Handle by ${handlingFlow.runtimeType}");
        return true;
      }
      print("[FlowManager] Not handled");
      return false;
    } else if (pendingStep != null && stepUri != null) {
      print(
          "[FlowManager] illegal state: This should never happen: _processPending should override pending step if stepUri is present");
      return false;
    } else if (pendingStep != null) {
      print("[FlowManager] Processing pending step");
      processResult(pendingStep, pendingArgs, messageContext);
      return true;
    } else if (stepUri != null) {
      final stepData = FlowStep.fromUri(stepUri, allStepsByUri); // Assuming FlowStep.fromUri is defined
      final theStep = stepData.$1;
      final args = stepData.$2;

      if (theStep == null) {
        print("[FlowManager] illegal state: COULD NOT FIND STEP FOR URI $stepUri");
        return false;
      } else {
        print("[FlowManager] Processing step by callback");
        processResult(theStep, args, messageContext);
        return true;
      }
    }

    print("[FlowManager] MISSING CASE OMG!");
    return false;
  }

  /// StepUri overrides pending.
  /// If user presented with an option to submit text or press button button is primary
  Future<String?> _processPending(StepUri? stepUri, int userId) async {
    if (stepUri != null) {
      await store.clearPending(userId);
      return null;
    } else {
      return store.retrievePending(userId);
    }
  }

  Future<void> processResult(FlowStep flowStep, List<String>? args, MessageContext messageContext) async {
    try {
      final reaction = await flowStep.handle(messageContext, args);
      final int? responseMessageId = await _react(reaction, messageContext);
      reaction.postCallback?.call(responseMessageId);
    } catch (error, st) {
      print('[FlowManager] Error while processing result: $error\n${st.toString()}');
    }
  }

  /// @return sent message id
  Future<int?> _react(Reaction result, MessageContext messageContext) async => switch (result) {
        ReactionNone _ => null,
        final ReactionResponse reactionResponse => () async {
            final uri = result.afterReplyUri;
            if (uri != null) {
              await store.setPending(messageContext.userId, uri);
            }
            return bot.replyWithButtons(
              messageContext.chatId,
              reactionResponse.editMessageId,
              reactionResponse.text,
              reactionResponse.buttons,
              reactionResponse.markdown,
            );
          }(),
        (final ReactionRedirect reactionRedirect) => () {
            final stepData = FlowStep.fromUri(reactionRedirect.stepUri, allStepsByUri);
            final step = stepData.$1;
            final args = stepData.$2;
            final text = reactionRedirect.text;
            final sendMessageId = text != null
                ? bot.replyWithButtons(
                    messageContext.userId,
                    reactionRedirect.editMessageId,
                    text,
                    [],
                    reactionRedirect.markdown,
                  )
                : null;
            processResult(step!, args, messageContext);
            return sendMessageId;
          }(),
        (final ReactionInvoice reactionInvoice) => () {
            final sendMessageId = bot.sendInvoice(
              reactionInvoice.chatId,
              reactionInvoice.invoiceInfo,
              reactionInvoice.preCheckoutUri,
              reactionInvoice.editMessageId,
            );
            return sendMessageId;
          }(),
        (final ReactionForeignResponse reaction) =>
          // final reactionForeignResponse = result as ReactionForeignResponse;
          bot.replyWithButtons(
            reaction.foreignUserId,
            reaction.editMessageId,
            reaction.text,
            reaction.buttons,
            reaction.markdown,
          ),
        (final ReactionComposed reactionComposed) => () async {
            for (var response in reactionComposed.responses) {
              _react(response, messageContext);
              await Future.delayed(Duration(milliseconds: 300));
            }
            return null;
          }(),
        // ignoring in case a new Reaction type is added
        // ignore: unreachable_switch_case
        _ => throw Exception("Unknown Reaction type: ${result.runtimeType}"),
      };
}
