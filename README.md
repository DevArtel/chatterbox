Chatterbox is a simple framework to build multi level Telegram Bot dialog flows.
It is build around [televerse](https://pub.dev/packages/televerse/) library.

## Features

Allows to process different kind of messages from user and reply to them within the given context

## Getting started

Can be used with both webhook and polling.


## Usage

### Webhook with Cloud Functions

```dart
@CloudFunction()
Future<void> function(Map<String, dynamic> updateJson) async {
  setTranslations(translations); //todo this is rubbish

  SharedDatabase.initialize();
  final store = ChatterboxStoreProxy(SharedDatabase.createDialogDao());
  final flows = <Flow>[
    LoginFlow(SharedDatabase.createTokenDao()),
  ];

  Chatterbox(SharedConfig.botToken, flows, store).invokeFromWebhook(updateJson);
}
```

## Additional information

