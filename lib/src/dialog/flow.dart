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

  bool willHandle(String? messageText, MessageContext messageContext) => false;
}

typedef StepUri = String;

const delimiter = "^";
const argsDelimiter = "-";

extension StepUriExtensions on StepUri {
  StepUri appendArgs(List<String> args) {
    if (args.isEmpty) return this;
    return "$this$delimiter${args.argsToPayload()}";
  }
}

extension ListStringExtensions on List<String> {
  String argsToPayload() => reduce((acc, arg) => "$acc$argsDelimiter$arg");
}

abstract class FlowStep {
  String get uri => runtimeType.toStepUri();

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

  static String _encode(String method, List<dynamic> args) {
    if (args.isNotEmpty) {
      final payload = args.map((arg) => arg.toString()).join(argsDelimiter);
      return "$method$delimiter$payload";
    } else {
      return method;
    }
  }
}
