import 'dart:convert';

import 'package:chatterbox/chatterbox.dart';
import 'package:dotenv/dotenv.dart';
import 'package:example/flows/coundown_game.dart';
import 'package:example/flows/menu.dart';
import 'package:example/flows/start.dart';
import 'package:example/flows/sticks_game.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(_handleRequest);
  final server = await shelf_io.serve(handler, 'localhost', 8080);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

final store = InMemoryStore();

Future<Response> _handleRequest(Request request) async {
  final env = DotEnv(includePlatformEnvironment: false)..load();
  final botToken = env['BOT_TOKEN'];

  if (botToken == null) {
    return Response.internalServerError(body: 'Missing BOT_TOKEN environment variable ');
  }

  final flows = <Flow>[
    StartFlow(),
    MenuFlow(),
    CountdownGameFlow(),
    TwentyOneSticksGameFlow(),
  ];

  final requestBody = await request.readAsString();
  final bodyMap = json.decode(requestBody);
  Chatterbox(botToken: botToken, flows: flows, store: store).invokeFromWebhook(bodyMap);

  return Response.ok('Request for "${request.url}"');
}
