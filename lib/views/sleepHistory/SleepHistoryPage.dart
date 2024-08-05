import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiveguys/presenters/SleepHistoryLogic.dart';
import 'package:fiveguys/views/sleepHistory/ColumnCLass.dart';
import 'package:fiveguys/views/sleepHistory/SleepHistoryGraphPage.dart';
import 'package:fiveguys/views/sleepHistory/SleepHistoryListPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/views/BaseAppBar.dart';
import 'package:fiveguys/presenters/SleepHistoryLogic.dart';

SleepHistoryLogic logic = SleepHistoryLogic();

class SleepHistoryPage extends StatefulWidget{
  @override
  State <SleepHistoryPage> createState() => SleepHistoryState();
}

class SleepHistoryState extends State<SleepHistoryPage>{

  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BaseAppBar(
      //   key: UniqueKey(), // Provide a unique key
      //   title: const Text('Sleep History'), // Set the app bar title
      //   backgroundColor:
      //   Theme.of(context).colorScheme.inversePrimary,
      //   appBar: AppBar(), // Set the background color
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (selectedOption == 1) ? SleepHistoryListPage() : SleepHistoryGraphPage(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 50,
        child: FloatingActionButton.extended(
          label: Text(
            (selectedOption == 1) ? 'Graph' : 'List',
            style: TextStyle(color: Colors.white),
          ),
          icon: (selectedOption == 1)
              ? Icon(Icons.bar_chart_rounded, color: Colors.white)
              : Icon(Icons.view_list_rounded, color: Colors.white),
          backgroundColor: Colors.lightBlue,
          //child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (selectedOption == 1) {
                selectedOption = 2;
              } else {
                selectedOption = 1;
              }
            });
          },
        ),
      ),

    );
}
}