import 'package:hive/hive.dart';

class ActivityLikesBox {
  static const key = 'likes';

  static void triggerLike(String id) {
    final box = Hive.box(key);
    if (box.containsKey(id)) {
      // Deleting instead of setting to false in order to avoid making the
      // local db grow unnecessarily over time
      box.delete(id);
    } else {
      box.put(id, true);
    }
  }
}
