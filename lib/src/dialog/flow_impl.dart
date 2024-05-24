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
  FlowManagerImpl(this._bot, this._store, this._flows);

  final BotFacade _bot;
  final PendingMessagesStore _store;
  final List<Flow> _flows;

  @override
  List<FlowStep> get allStepsByUri => _flows
      .map((flow) => flow.steps)
      .expand((steps) => steps)
      .map((step) => step())
      .toList();

  @override
  Future<bool> handle(MessageContext messageContext, [StepUri? stepUri]) async {
    final userId = messageContext.userId;
    final chatId = messageContext.chatId;

    final withMessage = messageContext.text == null ? "without message" : "with message '${messageContext.text}'";
    print("Handle invoked by $userId in ${messageContext.source.name}:${messageContext.chatId}: $withMessage");

    final String? pendingStepUrl = await _processPending(stepUri, userId, chatId);
    final pendingData = FlowStep.fromUri(pendingStepUrl, allStepsByUri);
    final pendingStep = pendingData.$1;
    final pendingArgs = pendingData.$2;

    if (pendingStep == null && stepUri == null) {
      final Flow? handlingFlow = _flows.firstWhereOrNull((flow) => flow.willHandle(messageContext));
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
  Future<String?> _processPending(StepUri? stepUri, int userId, int chatId) async {
    if (stepUri != null) {
      await _store.clearPending(userId, chatId);
      return null;
    } else {
      return _store.retrievePending(userId, chatId);
    }
  }

  Future<void> processResult(FlowStep flowStep, List<String>? args, MessageContext messageContext) async {
    try {
      if (messageContext.chatId < 0 && flowStep.requireAdmin) {
        /// Check if user is admin in the group
        final isAdmin = await _verifyAdmin(messageContext.chatId, messageContext.userId);
        if (!isAdmin) {
          print(
              '[FlowManager] ⚠️User ${messageContext.userId} is not an admin in chat ${messageContext.chatId}. To enable non admins to use the bot in groups, set requireAdmin to false in the flow step.');
          return;
        }
      }
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
              await _store.setPending(messageContext.userId, messageContext.chatId, uri);
            }
            return _bot.replyWithButtons(
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
                ? _bot.replyWithButtons(
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
            final sendMessageId = _bot.sendInvoice(
              reactionInvoice.chatId,
              reactionInvoice.invoiceInfo,
              reactionInvoice.preCheckoutUri,
              reactionInvoice.editMessageId,
            );
            return sendMessageId;
          }(),
        (final ReactionForeignResponse reaction) =>
          // final reactionForeignResponse = result as ReactionForeignResponse;
          _bot.replyWithButtons(
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

  Future<bool> _verifyAdmin(int chatId, int userId) async {
    final admins = await _bot.getChatAdmins(chatId);
    return admins.contains(userId);
  }
}
