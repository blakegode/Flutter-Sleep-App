import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:flutter/material.dart';
import '../models/SleepLog.dart';
import './sleepLogEntryForm.dart';
import 'BaseAppBar.dart';

class SleepLogEntryPage extends StatelessWidget {
  final DateTime date;
  final UserManagement userManagement = UserManagement();

  SleepLogEntryPage({required this.date});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userManagement.findUserSleepLog(date),
      builder: (context, AsyncSnapshot<SleepLog> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the sleep log
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if an error occurs
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once we have the sleep log, build the UI with the SleepLogEntryForm
          return Scaffold(
            appBar: BaseAppBar(
              key: UniqueKey(), // Provide a unique key
              title: const Text('Sleep Log Entry'), // Set the app bar title
              backgroundColor: AppColors.primaryColor,
              appBar: AppBar(), // Set the background color
            ),
            body: SleepLogEntryForm(
              onSubmit: (SleepLog sleepLog) async {
                await userManagement.addSleepLog(sleepLog);
                Navigator.pop(context);
              },
              sleepLog: snapshot.data!,
            ),
          );
        }
      },
    );
  }
}
