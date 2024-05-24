import 'package:chatterbox/chatterbox.dart';
import 'package:firedart/firedart.dart';

const _collectionDialogs = "dialogs";
const _fieldPendingStepUri = 'pending_step_uri';

class FirebaseDialogStore implements PendingMessagesStore {
  FirebaseDialogStore();

  CollectionReference get collection => Firestore.instance.collection(_collectionDialogs);

  static Future<void> initialize() async {
    if (!Firestore.initialized) {
      Firestore.initialize('chatterbox-example', useApplicationDefaultAuth: true);
    }
  }

  @override
  Future<String?> retrievePending(int userId, int chatId) async {
    final ref = collection.document('$chatId-$userId');

    if (!(await ref.exists)) {
      return null;
    }
    final doc = await ref.get();
    final stepId = doc[_fieldPendingStepUri];

    if (stepId != null) {
      ref.delete();
    }
    return stepId;
  }

  @override
  Future<void> setPending(int userId, int chatId, String stepUrl) async => collection.document('$chatId-$userId').update({
        _fieldPendingStepUri: stepUrl,
      });

  @override
  Future<void> clearPending(int userId, int chatId) => collection.document('$chatId-$userId').delete();
}
