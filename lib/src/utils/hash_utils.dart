import 'package:chatterbox/chatterbox.dart';

const String _alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.\$#";

extension HashId on Type {
  /// Produces a short hash id for a given type
  //todo won't work for same _InitialStep
  String toStepUri([List<String>? args]) {
    final String name = toString();
    final int num = _decode(name, _alphabet);
    final String shortId = num.toRadixString(16);
    print("[HashIds] generate id $shortId for $name");

    if (args != null) {
      return (shortId).appendArgs(args);
    } else {
      return shortId;
    }
  }
}

int _decode(String s, String symbols) {
  final int B = symbols.length;
  int num = 0;
  for (final ch in s.split('')) {
    num *= B;
    num += symbols.indexOf(ch);
  }
  return num;
}
