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
