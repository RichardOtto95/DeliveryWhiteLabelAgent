import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
part 'notifications_store.g.dart';

class NotificationsStore = _NotificationsStoreBase with _$NotificationsStore;
abstract class _NotificationsStoreBase with Store {

  @action
  Future<List<List>> getNotifications() async {
    List oldNotifications = [];
    List newNotifications = [];
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot allNotifications = await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .collection('notifications')
        .orderBy('sended_at', descending: true)
        .get();

    for (var i = 0; i < allNotifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = allNotifications.docs[i];
      if (notificationDoc['viewed']) {
        oldNotifications.add(notificationDoc);
      } else {
        newNotifications.add(notificationDoc);
      }
    }

    return [
      newNotifications,
      oldNotifications,
    ];
  }

  @action
  String getTime(Timestamp sendedAt) {
    // DateTime dateTime = sendedAt.toDate().toUtc();
    DateTime dateTime = sendedAt.toDate();
    DateTime now = DateTime.now();
    // print('difference: ${now.difference(dateTime).inMinutes}');
    // print('difference: ${now.difference(dateTime).inHours}');
    // print('difference: ${now.difference(dateTime).inDays}');
    if (now.difference(dateTime).inMinutes < 60) {
      return "${now.difference(dateTime).inMinutes} min";
    }

    if (now.difference(dateTime).inHours < 24) {
      return "${now.difference(dateTime).inHours} h";
    }

    if (now.difference(dateTime).inDays < 2) {
      return "${now.difference(dateTime).inDays} dia";
    }

    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    // String hour = dateTime.hour.toString().padLeft(2, '0');
    // String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day/$month/$year";
    // return "$day/$month/$year $hour:$minute";
  }

  @action
  Future<void> visualizedAllNotifications() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot allNotifications = await FirebaseFirestore.instance
        .collection('agents')
        .doc(_user!.uid)
        .collection('notifications')
        .where('viewed', isEqualTo: false)
        .get();

    for (var i = 0; i < allNotifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = allNotifications.docs[i];
      await notificationDoc.reference.update({"viewed": true});
    }
  }
}