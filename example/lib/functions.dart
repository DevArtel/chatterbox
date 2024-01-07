import 'dart:convert';

import 'package:chatterbox/chatterbox.dart';
import 'package:dotenv/dotenv.dart';
import 'package:example/flows/coundown_game.dart';
import 'package:example/flows/menu.dart';
import 'package:example/flows/start.dart';
import 'package:example/flows/sticks_game.dart';
import 'package:example/storage/firebase_dialog_store.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  return _handleRequest(request);
}

Future<Response> _handleRequest(Request request) async {
  print('Request for "${request.url}"');

  final requestBody = await request.readAsString();
  print('Request body: ${requestBody}');

  final env = DotEnv(includePlatformEnvironment: false)..load();
  final botToken = env['BOT_TOKEN'];

  if (botToken == null) {
    return Response.internalServerError(body: 'Missing BOT_TOKEN environment variable ');
  }

  await FirebaseDialogStore.initialize();

  final flows = <Flow>[
    StartFlow(),
    MenuFlow(),
    CountdownGameFlow(),
    TwentyOneSticksGameFlow(),
  ];

  final bodyMap = json.decode(requestBody);
  Chatterbox(botToken: botToken, flows: flows, store: FirebaseDialogStore()).invokeFromWebhook(bodyMap);

  return Response.ok('Request for "${request.url}"');
}
