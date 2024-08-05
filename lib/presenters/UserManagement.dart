import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/SleepLog.dart';
import 'package:fiveguys/presenters/notifications.dart';

class UserManagement {
  static final UserManagement _instance = UserManagement._internal();

  String _userId = "-1";
  String _userPhotoURL = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg";
  String _displayName = "User";

  factory UserManagement() {
    return _instance;
  }

  UserManagement._internal();

  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<bool> createUser(String userId, String userPhotoURL, int age, DateTime targetWakeTime, bool hasNotificationsEnabled) async {
    _userId = userId;
    _userPhotoURL = userPhotoURL;

    if (userId == "-1") {
      //return false;
      //TODO during production it should return false, for now the default "shared" user will be id -1
    }

    await usersCollection.doc(userId).set({
      'id': userId,
      'sleepLogs': [],
      'targetSleepTime': targetWakeTime.add(Duration(hours: -8)),
      'targetWakeTime': targetWakeTime,
      'age': age,
      'hasNotificationsEnabled': hasNotificationsEnabled,
    });
    return true;
  }

  String getUserPhotoURL() {
    return _userPhotoURL;
  }

  Future<bool> isNewUser(String userPhotoURL, String userId, String displayName) async {
    _userId = userId;
    _userPhotoURL = userPhotoURL;
    _displayName = displayName;
    try {
      final docSnapshot = await usersCollection.doc(userId).get();
      return !docSnapshot.exists;
    } catch (e) {
      // Handle any potential errors here
      print("Error checking if user is new: $e");
      return false;
    }
  }

  String getDisplayName() {
    return _displayName;
  }


  Future<SleepLog> findUserSleepLog(DateTime date) async {
    try {
      final userDocument = await usersCollection.doc(_userId).get();
      if (userDocument.exists) {
        final List<dynamic>? sleepLogsData = userDocument.data()?['sleepLogs'];

        // Initialize an empty list if sleepLogsData is null
        List<Map<String, dynamic>> sleepLogs = sleepLogsData != null
            ? List<Map<String, dynamic>>.from(sleepLogsData)
            : [];

        for (var sleepLogData in sleepLogs) {
          // Convert the 'date' field from Timestamp to DateTime
          Timestamp timestamp = sleepLogData['date'];
          DateTime sleepLogDate = timestamp.toDate();

          // Perform date comparison with the converted DateTime objects
          if (sleepLogDate.year == date.year &&
              sleepLogDate.month == date.month &&
              sleepLogDate.day == date.day) {
            // Return the matched sleep log
            return SleepLog.fromMap(sleepLogData);
          }
        }
      }
    } catch (e) {
      print("Error finding user sleep log: $e");
    }
    // If no matching sleep log is found, return a default sleep log
    return SleepLog(date, "","",5, 5, 5, 5, DateTime(date.year, date.month, date.day, 23, 0), DateTime(date.year, date.month, date.day, 7, 0));
  }

  Future<SleepLog?> findSelectedSleepLog(DateTime date) async {
    try {
      final userDocument = await usersCollection.doc(_userId).get();
      if (userDocument.exists) {
        final List<dynamic>? sleepLogsData = userDocument.data()?['sleepLogs'];

        // Initialize an empty list if sleepLogsData is null
        List<Map<String, dynamic>> sleepLogs = sleepLogsData != null
            ? List<Map<String, dynamic>>.from(sleepLogsData)
            : [];

        for (var sleepLogData in sleepLogs) {
          // Convert the 'date' field from Timestamp to DateTime
          Timestamp timestamp = sleepLogData['date'];
          DateTime sleepLogDate = timestamp.toDate();

          // Perform date comparison with the converted DateTime objects
          if (sleepLogDate.year == date.year &&
              sleepLogDate.month == date.month &&
              sleepLogDate.day == date.day) {
            // Return the matched sleep log
            return SleepLog.fromMap(sleepLogData);
          }
        }
      }
    } catch (e) {
      print("Error finding user sleep log: $e");
    }

    return null;
  }


  Future<void> addSleepLog(SleepLog sleepLog) async {
    try {
      final userDocument = await usersCollection.doc(_userId).get();
      List<dynamic>? sleepLogsData = userDocument.data()?['sleepLogs'];

      // Initialize an empty list if sleepLogsData is null
      List<Map<String, dynamic>> sleepLogs = sleepLogsData != null
          ? List<Map<String, dynamic>>.from(sleepLogsData)
          : [];

      // Convert the SleepLog object to a Map
      Map<String, dynamic> sleepLogMap = sleepLog.toMap();

      // Iterate through existing sleep logs to update if the date matches
      for (int i = 0; i < sleepLogs.length; i++) {
        Map<String, dynamic> currSleepLog = sleepLogs[i];
        if (currSleepLog['date'].toDate() == sleepLogMap['date']) {
          sleepLogs[i] = sleepLogMap; // Update the existing sleep log
          await usersCollection.doc(_userId).update({'sleepLogs': sleepLogs});
          return; // Exit the method after updating
        }
      }

      // If no matching sleep log is found, add the new sleep log
      sleepLog.date = sleepLog.date.add(Duration(hours: 5));
      Map<String, dynamic> sleepLogMap1 = sleepLog.toMap();

      sleepLogs.add(sleepLogMap1);
      await usersCollection.doc(_userId).update({'sleepLogs': sleepLogs});
    } catch (e) {
      print("Error adding sleep log: $e");
    }
  }

  // For organizational purposes, the below functions are written by Elijah



  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(){
    return usersCollection.doc(_userId).get();
  }

  Future<int> getAge() async {
    final userDocument = await getUserDoc();
    return userDocument.data()?['age'];
  }

  Future<Map<String, dynamic>?> getData() async{
    final userDocument = await getUserDoc();
    final userData = userDocument.data();

//    final sleepLogs = userData?['sleepLogs'];

    return userData;

  }


  //End of functions written by Elijah

}
