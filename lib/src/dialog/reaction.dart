import 'package:chatterbox/chatterbox.dart';
import 'package:chatterbox/src/model/sticker_model.dart';
import 'package:collection/collection.dart';

sealed class Reaction {
  final Function(int?)? postCallback;

  Reaction(this.postCallback);
}

class ReactionResponse extends Reaction {
  /// Text to send to user
  final String text;

  /// If true, then text will be parsed as markdown
  final bool markdown;

  /// Instead of sending new message to user this message will be updated
  final int? editMessageId;

  /// Buttons to display to user
  final List<InlineButton> buttons;

  /// This step will be invoked after user reply with user message passed as param
  final String? afterReplyUri;

  final bool showLinkPreview;

  /// Determins when to trigger afterReplyUri. If null, then it will be triggered after any user reply
  AfterReplyUriFilter? afterReplyUriTrigger;

  ReactionResponse({
    required this.text,
    this.markdown = false,
    this.editMessageId,
    this.buttons = const [],
    this.afterReplyUri,
    this.afterReplyUriTrigger,
    this.showLinkPreview = false,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

class ReactionRedirect extends Reaction {
  final String stepUri;
  final String? text;
  final bool markdown;
  final int? editMessageId;

  ReactionRedirect({
    required this.stepUri,
    this.text,
    this.markdown = false,
    this.editMessageId,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

class ReactionInvoice extends Reaction {
  /// chatId - Unique identifier for the target chat or username of the target channel (in the format @channelusername)
  final int chatId;
  final InvoiceInfo invoiceInfo;
  final String preCheckoutUri;
  final int? editMessageId;

  ReactionInvoice({
    required this.chatId,
    required this.invoiceInfo,
    required this.preCheckoutUri,
    this.editMessageId,
    Function(int?)? postCallback,
  }) : super(postCallback);
}

/// Return None to ignore user input
class ReactionNone extends Reaction {
  ReactionNone() : super(null);
}

/// Use this when you want bot to talk to other user
class ReactionForeignResponse extends Reaction {
  ReactionForeignResponse({
    required this.foreignUserId,
    required this.text,
    this.markdown = false,
    this.editMessageId,
    this.buttons = const [],
    this.sticker,
    this.afterReplyUri,
    Function(int?)? postCallback,
    this.showLinkPreview = false,
  }) : super(postCallback);

  final int foreignUserId;
  final String text;
  final bool markdown;
  final int? editMessageId;
  final List<InlineButton> buttons;
  final StickerModel? sticker;
  final String? afterReplyUri;
  final bool showLinkPreview;
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

class AfterReplyUriFilter {
  AfterReplyUriFilter(this.userId, this.messageText);

  final int? userId;
  final String? messageText;
}
