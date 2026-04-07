import 'dart:async';

import 'package:televerse/televerse.dart';

typedef SuccessfulPaymentHandler = FutureOr<void> Function(Context ctx);

extension TeleverseExtensions on Bot {
  void onSuccessfulPayment(SuccessfulPaymentHandler handler) {
    filter(
      (ctx) => ctx.message?.successfulPayment != null,
      (ctx) => handler(ctx),
    );
  }
}
