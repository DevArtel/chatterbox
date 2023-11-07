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
Future<Response> function(Map<String, dynamic> updateJson) async {
  try {
    final flows = <Flow>[
      //todo
    ];

    Chatterbox(Config.botToken, flows, StoreProxy()).invokeFromWebhook(updateJson);
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (error) {
    return Response.badRequest();
  }
}
```

## Coding dialog flows

### Creating Flows

### Reacting to user input

[ReactionResponse] is a simple reaction that allows to respond with a test to user input
```dart
ReactionResponse(
  /// Required text message to reply to user
  text: 'What is your favorite number?',
  /// Optional buttons
  buttons: [
    InlineButton(
      /// Button text
      title: 'Seventy three',
      /// Uri of a step to be invoked when this button is pressed
      nextStepUri: NextStep.toStepUri().appendArgs('73')
    ),
  ],
);
```
It can also contain buttons


# Setup Google Cloud Run
1. Install gcloud console utility
2. gcloud init
3. Create a project and give it a unique id, alternatively you can create a project at https://console.cloud.google.com/
4. Go to Google Cloud run and do following
5. Enable Identity and Access Management (IAM) API https://console.cloud.google.com/apis/library/iam.googleapis.com?project=getrid-0
6. Trigger a build https://console.cloud.google.com/cloud-build/triggers?project=getrid-0
7. Add Secrets https://console.cloud.google.com/marketplace/product/google/secretmanager.googleapis.com?returnUrl=%2Fsecurity%2Fsecret-manager%3Fproject%3Dgetrid-0&project=getrid-0
