import 'package:chatterbox/src/dialog/flow_impl.dart';
import 'package:chatterbox/src/dialog/reaction.dart';
import 'package:chatterbox/src/model/message_context.dart';
import 'package:chatterbox/src/utils/hash_utils.dart';
import 'package:collection/collection.dart';

abstract class CommandFlow extends Flow {
  String get command;
}

abstract class Flow {
  List<StepFactory> get steps;

  FlowStep get initialStep => steps.first();

  bool willHandle(MessageContext messageContext) => false;
}

typedef StepUri = String;

const delimiter = "^";
const argsDelimiter = "-";

extension StepUriExtensions on StepUri {
  StepUri appendArgs([List<String>? args]) {
    if (args != null && args.isNotEmpty == true) {
      return "$this$delimiter${args.argsToPayload()}";
    } else {
      return this;
    }
  }
}

extension ListStringExtensions on List<String> {
  String argsToPayload() => reduce((acc, arg) => "$acc$argsDelimiter$arg");
}

abstract class FlowStep {
  String get uri => runtimeType.toStepUri();

  //TODO: In future we might want to enable more granular check with ChatMemberStatus(creator, administrator, member)
  /// Indicates whether this step requires the user to be a group administrator
  /// when interacting within a group chat.
  ///
  /// Defaults to `false`. If set to `true`, only users with administrator
  /// In individual chats, this property has no effect.
  bool get requireAdmin => true;

  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]);

  static (FlowStep?, List<String>?) fromUri(StepUri? pendingStepUri, List<FlowStep> allSteps) {
    if (pendingStepUri == null) {
      return (null, null);
    }
    final decodedData = _decode(pendingStepUri);
    final stepId = decodedData.$1;
    final args = decodedData.$2;
    final step = allSteps.firstWhereOrNull((s) => s.uri == stepId);
    return (step, args);
  }

  static (String, List<String>?) _decode(String json) {
    final parts = json.split(delimiter);
    final payload = parts.length > 1 ? parts.sublist(1).join(delimiter).split(argsDelimiter) : null;
    return (parts.first, payload);
  }
}
