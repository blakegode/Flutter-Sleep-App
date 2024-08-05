

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/views/sleepHistory/ColumnCLass.dart';
import '../models/SleepLog.dart';
import 'UserManagement.dart';

//todo
/*
  -Implement sorting algorithm to display entries by date

  -Add additional data points for each row

  -Make it look nice

  -Make a class modeling the entries?
 */

UserManagement userManagement = UserManagement();

const secondsInDay = 86400;



class SleepHistoryLogic {

  int _getRecomendedSleepSeconds(int age){
    if (age < 6){
      return 60 * 60 * 12;
    }else if(age <= 12){
      return 60 * 60 * 10;
    }else if (age <= 18){
      return 60 * 60 * 9;
    }else{
      return 60 * 60 * 7;
    }
    return -1;
  }

  Future<List> getRows()async{


    List sleepEntries = await getSleepEntries();
    List sortedSleepEntries = GetSortedEntries(sleepEntries);
    List valuesList = [];

    int i = 0;

    for (var entry in sortedSleepEntries){
      Map<String, String> values = Map();

      final dateFormat = entry['date'].toDate().toString().substring(0,10);

      Timestamp sleepTime = entry['sleepTime'];//.toDate();
      Timestamp wakeTime = entry['wakeTime'];
      final sleepQuality = entry['sleepQuality'];
      final message = entry['text'];

      String diff = durationHHmm(sleepTime, wakeTime);



      final sleepAt = time(sleepTime);

      final wakeAt = time(wakeTime);

      values["dateFormat"] = "$dateFormat";
      values["sleepQuality"] = "$sleepQuality";
      values["message"] = "$message";
      values["sleepDifference"] = diff;
      values["sleepTime"] = "$sleepAt";
      values["wakeTime"] = "$wakeAt";

      valuesList.add(values);

      //ColumnClass c = ColumnClass(dateFormat, sleepQuality, diff, message);

    }
    /*
    Column c = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (ColumnClass r in list)
            r
        ]
    );*/

    return valuesList;
  }

  String time(Timestamp time){
    var hour = time.toDate().hour;
    final minute = time.toDate().minute;
    String ampm = "am";
    if (hour > 12){
      hour -= 12;
      ampm = "pm";
    }
    if (hour == 0){
      hour = 12;
    }
    if ("$minute".length == 1){
      return "$hour:0$minute$ampm";
    }
    return "$hour:$minute$ampm";
  }

  int getSleepEntryListLength(){
    int l = 0;
    ()async{
      final list = await getSleepEntries();
      l = list.length;
    };
    return l;
  }

  Future<List> getSleepEntries()async{
    final userDocument = await userManagement.getUserDoc();
    final userData = userDocument.data();
    final sleepLogs = userData?['sleepLogs'] as List;
    return sleepLogs;
  }

  Future<Map> getSleepEntry(int i)async {
    final entries = await getSleepEntries();
    return entries[i];
  }

  Future<String> getSleepQuality()async{
    final sleep = await getSleepEntry(0);
    final seconds = sleep['date'];
    final date = seconds.toDate();
    return "$date";
  }

  Future<bool> didSleepToday()async{
    List sleepEntries = await getSleepEntries();
    List sortedSleepEntries = GetSortedEntries(sleepEntries);
    const secondsInDay = 86400;
    var now = Timestamp.now();

    for (var entry in sortedSleepEntries){
      var date = entry['date'];
      var diff = now.seconds - date.seconds;
      if (diff < secondsInDay){
        return true;
      }
    }
    return false;
  }

  Future<int> getSleepStreak(bool goodSleep)async{
    int streak = 0;
    var entries = GetSortedEntries(await getSleepEntries());
    var now = Timestamp.now().seconds;

    for (int i = 0; i < entries.length; i++){
      var entry = entries[i];
      if ((now - entry['date'].seconds) < (secondsInDay * (i + 1))){
        var temp1 = entry['date'];

        // Return only the number of whole days

        if (goodSleep){
          int recomendedSleepSeconds = _getRecomendedSleepSeconds(await userManagement.getAge());
          var duration = entry['wakeTime'].seconds - entry['sleepTime'].seconds;
          if (duration < 0){
            duration += secondsInDay;
          }

          if (duration >= recomendedSleepSeconds){
            streak++;
          }else{
            break;
          }
        }else{
        streak++;}
      }
    }
    return streak;
  }

  Future<bool> sleptWellToday()async{
    List sleepEntries = await getSleepEntries();
    List sortedSleepEntries = GetSortedEntries(sleepEntries);
    var now = Timestamp.now();

    for (var entry in sortedSleepEntries){
      var date = entry['date'];
      var diff = now.seconds - date.seconds;
      if (diff < secondsInDay){
        if (entry['sleepQuality'] > 5){
          return true;

        }
      }
    }
    return false;

  }



  String durationHHmm(Timestamp sleep, Timestamp wake){
    var sleepDT = DateTime.fromMicrosecondsSinceEpoch(sleep.microsecondsSinceEpoch);
    var sleepHours = sleepDT.hour;
    var sleepMinutes = sleepDT.minute;
    var wakeDT = DateTime.fromMicrosecondsSinceEpoch(wake.microsecondsSinceEpoch);
    var wakeMinutes = wakeDT.minute;
    var wakeHours = wakeDT.hour;

    var hourDiff = (24 - sleepHours) + wakeHours;
    var minuteDiff = wakeMinutes - sleepMinutes;

    if (minuteDiff < 0){
      minuteDiff += 60;
      hourDiff-=1;
    }

    if ('$minuteDiff'.length == 1){
      return "$hourDiff:0$minuteDiff";
    }

    return "$hourDiff:$minuteDiff";
  }

  /*
  String durationHHmm(Timestamp sleep, Timestamp wake) {
    const secondsInDay = 86400;
    var difference = 0;



    if (wake.seconds < sleep.seconds) {
      int wake2 = wake.seconds + secondsInDay;
      difference = wake2 - sleep.seconds;
    } else {
      difference = wake.seconds - sleep.seconds;
    }

    var minutes = (difference / 60).round();
    var hours = (minutes / 60).round();
    minutes = minutes - (hours * 60);
    if (minutes < 0) {
      minutes *= -1;
    }
    var minutesStr = "$minutes";
    if (minutesStr == "0") {
      minutesStr = "00";
    }
    return "$hours:$minutesStr";
  }*/

  List GetSortedEntries(List e) {
    List entries = e;

    for (int i = 0; i < entries.length; i++) {
      for (int j = i; j > 0; j--) {
        Timestamp leftEntry = entries[j - 1]['date'];
        Timestamp rightEntry = entries[j]['date'];
        if (leftEntry.compareTo(rightEntry) < 0) {
          var temp = entries[j];
          entries[j] = entries[j - 1];
          entries[j - 1] = temp;
        }
      }
    }


    return entries;
  }

  List GetReversedEntries(List e) {
    List entries = e;

    for (int i = 0; i < entries.length; i++) {
      for (int j = i; j > 0; j--) {
        Timestamp leftEntry = entries[j - 1]['date'];
        Timestamp rightEntry = entries[j]['date'];
        if (leftEntry.compareTo(rightEntry) > 0) { // Change to compare in descending order
          var temp = entries[j];
          entries[j] = entries[j - 1];
          entries[j - 1] = temp;
        }
      }
    }

    return entries;
  }


  List<SleepLog> getSleepLogEntries(List<Map<String, dynamic>> sleepLogList) {
    List<SleepLog> entries = [];
    for (var map in sleepLogList) {
      entries.add(SleepLog.fromMap(map));
    }
    return entries;
  }

  DateTime getWeekStartDate(DateTime date) {
    int difference = date.weekday - DateTime.monday;
    DateTime weekStartDate = date.subtract(Duration(days: difference));
    return DateTime(weekStartDate.year, weekStartDate.month, weekStartDate.day);
  }


  DateTime getWeekEndDate(DateTime date) {
    int difference = date.weekday - DateTime.sunday;
    DateTime weekStartDate = date.subtract(Duration(days: difference));
    return weekStartDate;
  }

  DateTime getMonthStartDate(DateTime date) {
    return DateTime(date.year, date.month, 1, 0);
  }

}



