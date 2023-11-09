## 1.0.6
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
