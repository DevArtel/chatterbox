## 1.7.1

- Fix: Negative int values cannot be used as args between steps

## 1.7.0

- Group Interactions: Added support for bot interactions within Telegram groups.
- Admin-Only Steps: Introduced FlowStep#requireAdmin to restrict certain steps to group admins (enabled by default).

## 1.6.0

- Override pendingUri, when stepUri is provided. This allows to provide user with both InlineButton and text input
  options. Button will be processed first, and if not provided, text input will be processed.
- Update Televerse dependency to 1.14.0

## 1.5.0

- Update Televerse dependency to 1.13.1

## 1.4.0

- Add onChannelPost handler

## 1.3.1

- Point Televerse to alternative repo with fix For StickerSet model until official Televerse fix is released

## 1.3.0

- Update Televerse dependency to 1.12.7

## 1.2.0

- Introduce Invoice payment flow

## 1.1.0

- Fix command handling for media file processing

## 1.0.9

- Introduce possibility to send markdown v1 messages
- Handle commands send as captions with media files
- Fix MessageContext#user field for CallbackQuery flow

## 1.0.8 Locale

- Add original message to MessageContext
- When receiving a command pass text via MessageContext.text field

## 1.0.7 Locale

- Add user locale to MessageContext

## 1.0.6 Payments

- Implement processing payments functions
- Implement SendInvoice functionality
- Rename ChatterboxStore to PendingMessagesStore
- Introduce default InMemoryStore
- Add preCheckoutInfo to MessageContext
- Implement processPreCheckoutQuery update
- Introduce process SuccessfulPayment update

## 1.0.5

- Implement handling Photo, Video and Sticker Media files (pass them via MessageContext#mediaFile)

## 1.0.4

- Add Message text inside MessageContext instead of appending to args
- Add args field to toStepUri util function

## 1.0.4

- Add Message text inside MessageContext instead of appending to args
- Add args field to toStepUri util function

## 1.0.3

- Fix working with pending message

## 1.0.2

- Introduce toStepUri() function, that is used to reference between steps
- Process callback for InlineButtons

## 1.0.1

- Add verification for InlineButtons
- Process callback for InlineButtons

## 1.0.0

- Initial version.
