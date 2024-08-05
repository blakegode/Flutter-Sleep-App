import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:fiveguys/views/sleepLogEntryPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import '../models/SleepLog.dart';
import 'BaseAppBar.dart';

class HealthySleepCalendar extends StatefulWidget {

  @override
  State<HealthySleepCalendar> createState() => sleepCalendar();
}

class sleepCalendar extends State<HealthySleepCalendar> {
  DateTime today = DateTime.now();
  DateTime dateChosen = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  SleepLog? selectedSleepLog;
  UserManagement userManagement = UserManagement();
  AppColors appColors = AppColors();
  void _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      today = day;
      dateChosen = day;
    });
    final selectedLog = await userManagement.findSelectedSleepLog(day);
    setState(() {
      selectedSleepLog = selectedLog;
    });
  }

  @override
  void initState() {
    super.initState();
    _onDaySelected(today, today);
  }

//https://stackoverflow.com/questions/68255465/add-new-widget-upon-clicking-floating-action-button-in-flutter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: BaseAppBar(
        //   key: UniqueKey(), // Provide a unique key
        //   title: const Text('Sleep Calendar'), // Set the app bar title
        //   backgroundColor:
        //   Theme.of(context).colorScheme.inversePrimary,
        //   appBar: AppBar(), // Set the background color
        // ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(


              opacity: 0.75,
              child: Image.asset(
                'assets/background2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child:  Container(
                      decoration: BoxDecoration(
                        color: Color(0xAA000000),
                        // color: Color(0x35FBF3E6),
                        // image: DecorationImage.lerp(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TableCalendar(
                        calendarStyle: const CalendarStyle(
                          todayTextStyle: TextStyle(
                            color: AppColors.accentColor,
                          ),
                          // selectedTextStyle: TextStyle(
                          //   color: Colors.white,
                          // ),
                          // defaultTextStyle: TextStyle(
                          //   color: AppColors.primaryColor,
                          // ),
                          // weekendTextStyle: TextStyle(
                          //   color: AppColors.accentColor,
                          // ),
                          //
                          todayDecoration: BoxDecoration(
                            color: Color(0x2F0000000), // Change color of today's date
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: AppColors.primaryColor, // Change color of selected date
                            shape: BoxShape.circle,
                          ),
                        ),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) => isSameDay(day, today),
                        focusedDay: today,
                        firstDay: DateTime.utc(2024,01,01),
                        lastDay: DateTime.now().add(const Duration(days: 1)),
                        onDaySelected: _onDaySelected,
                      ),
                    ),
                  ),
                  if (selectedSleepLog != null) ...[
                    const SizedBox(height: 10), // Add some space between calendar and sleep log info
                    const Text(
                      'Sleep Log Information:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Entry:', style: TextStyle(fontSize: 18),),
                              Text('Stress:', style: TextStyle(fontSize: 18)),
                              Text('Stress Affect:', style: TextStyle(fontSize: 18),),
                              Text('Sleep Time:', style: TextStyle(fontSize: 18),),
                              Text('Wake Time:', style: TextStyle(fontSize: 18),),
                              Text('Sleep Quality', style: TextStyle(fontSize: 18),),
                              Text('Yesterdays Energy', style: TextStyle(fontSize: 18),),
                              Text('Todays Energy', style: TextStyle(fontSize: 18),),
                            ]
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            selectedSleepLog!.text.length < 15
                                ? Text(selectedSleepLog!.text.trim().replaceAll("\n", ""), style: TextStyle(fontSize: 18),)
                                : GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sleep Log ${selectedSleepLog?.date.toString().split(" ")[0]}'),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          selectedSleepLog!.text,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                '${selectedSleepLog!.text.substring(0, 15).trim().replaceAll("\n", "")}...',
                                style: const TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            selectedSleepLog!.stressText.length < 15
                                ? Text(selectedSleepLog!.stressText.trim().replaceAll("\n", ""), style: TextStyle(fontSize: 18),)
                                : GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sleep Log ${selectedSleepLog?.date.toString().split(" ")[0]}'),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          selectedSleepLog!.stressText,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                '${selectedSleepLog!.stressText.substring(0, 15).trim().replaceAll("\n", "")}...',
                                style: const TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),

                            Text('${selectedSleepLog!.stressLevel.toStringAsFixed(0)}/10', style: TextStyle(fontSize: 18),),
                            Text('${selectedSleepLog!.sleepTime.hour}:${selectedSleepLog!.sleepTime.minute}', style: TextStyle(fontSize: 18),),
                            Text('${selectedSleepLog!.wakeTime.hour}:${selectedSleepLog!.sleepTime.minute}', style: TextStyle(fontSize: 18),),
                            Text('${selectedSleepLog!.sleepQuality.toStringAsFixed(0)}/10', style: TextStyle(fontSize: 18),),
                            Text('${selectedSleepLog!.previousDaysActivityLevel.toStringAsFixed(0)}/10', style: TextStyle(fontSize: 18),),
                            Text('${selectedSleepLog!.currentDaysActivityLevel.toStringAsFixed(0)}/10', style: TextStyle(fontSize: 18),),
                          ],
                        )
                      ],
                    ),
                  ]
                  else ...[
                    const SizedBox(height: 20),
                    const Text(
                      'No sleep log recorded for this day',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ],
              ),
            )
          ]
        ),

        //Button to add sleep log info
        floatingActionButton: FloatingActionButton.extended(
            label: const Icon(Icons.add),
            backgroundColor: AppColors.primaryColor,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepLogEntryPage(date: dateChosen)),
              );

            }
        ),
      );
  }
}