import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static DatabaseReference userRef() {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseDatabase database = FirebaseDatabase.instance;
    return database.ref().child(user.uid);
  }

  static Future<String?> imageProfile(String userUid) async {
    String? result;
    FirebaseStorage storage = FirebaseStorage.instance;

    List<Reference> items = (await storage.ref().list()).items;
    for (Reference ref in items) {
      String uid = ref.name.split('.')[0];
      if (uid == userUid) {
        result = await storage.ref(ref.fullPath).getDownloadURL();
      }
    }

    return result;
  }
}
