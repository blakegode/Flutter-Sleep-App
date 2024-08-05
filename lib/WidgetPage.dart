import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/main.dart';
import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:fiveguys/presenters/sleepCalculatorLogic.dart';
import 'package:fiveguys/views/BaseAppBar.dart';
import 'package:fiveguys/views/SleepSheep.dart';
import 'package:fiveguys/views/sleepHistory/SleepHistoryPage.dart';
import 'package:fiveguys/views/sleepCalendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/views/sleepCalculator.dart';
import 'package:fiveguys/views/notification_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fiveguys/views/YoutubeState.dart';

void main() {
  runApp(const WidgetPage());
}

class WidgetPage extends StatefulWidget {
  const WidgetPage({Key? key});

  @override
  State<WidgetPage> createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  int currentPageIndex = 0;
  UserManagement userManagement = UserManagement();

  final List<Widget> _pages = <Widget>[
    HealthySleepCalendar(),
    SleepCalculator(),
    SleepHistoryPage(),
    YoutubeState(),
    //NotificationScreen(),
    SleepSheep(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        key: UniqueKey(), // Provide a unique key
        title: Text('Welcome ${userManagement.getDisplayName().split(" ")[0]}'), // Set the app bar title
        backgroundColor:
        AppColors.primaryColor,
        appBar: AppBar(), // Set the background color
      ),
      body: Center(
        child: _pages.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: Colors.white,
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pets),
            label: 'Sheep',
          )
        ],
      ),
    );
  }
}
