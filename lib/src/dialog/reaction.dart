import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/src/model/sticker_model.dart';
import 'package:collection/collection.dart';
import 'package:televerse/telegram.dart';

sealed class Reaction {
  final Function(int?)? postCallback;

  Reaction(this.postCallback);
}

class ReactionResponse extends Reaction {
  /// Text to send to user
  final String text;

  /// Instead of sending new message to user this message will be updated
  final int? editMessageId;

  /// Buttons to display to user
  final List<InlineButton> buttons;

  /// This step will be invoked after user reply with user message passed as param
  final String? afterReplyUri;

  ReactionResponse({
    required this.text,
    this.editMessageId,
    this.buttons = const [],
    this.afterReplyUri,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

class ReactionRedirect extends Reaction {
  final String stepUri;
  final String? text;
  final int? editMessageId;

  ReactionRedirect({
    required this.stepUri,
    this.text,
    this.editMessageId,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

class ReactionInvoice extends Reaction {
  final int userId;
  final SuccessfulPayment paymentInvoiceInfo;

  ReactionInvoice({
    required this.userId,
    required this.paymentInvoiceInfo,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

/// Return None to ignore user input
class ReactionNone extends Reaction {
  ReactionNone() : super(null);
}

/// Use this when you want bot to talk to other user
class ReactionForeignResponse extends Reaction {
  final int foreignUserId;
  final String text;
  final int? editMessageId;
  final List<InlineButton> buttons;
  final StickerModel? sticker;
  final String? afterReplyUri;

  ReactionForeignResponse({
    required this.foreignUserId,
    required this.text,
    this.editMessageId,
    this.buttons = const [],
    this.sticker,
    this.afterReplyUri,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

class ReactionComposed extends Reaction {
  final List<Reaction> responses;

  ReactionComposed({
    required this.responses,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

FlowStep? findById(List<FlowStep> steps, String stepId) {
  return steps.firstWhereOrNull((step) => step.uri == stepId);
}
