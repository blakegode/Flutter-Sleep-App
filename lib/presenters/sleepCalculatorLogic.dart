
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiveguys/enums/SleepCalculatorOptons.dart';

import 'UserManagement.dart';

UserManagement userManagement = UserManagement();



Future<String> getTargetTime(String? hour, String? minute, Options? choice, AMPM? ampm) async {
  String result = "Invalid Hour/Minute Format";

  if (hour == null || hour == ""){
    return "Enter hour";
  }
  if (minute == null || minute == ""){
    return "Enter minute";
  }

  if (int.parse(hour) > 12 || int.parse(minute) > 59){
    return "Invalid Input";
  }

  String command, ampmStr = "AM";
  const minutesInDay = 1440;
  const minutesIn12Hrs = 720;
  int sleepNeededMinutes = 8 * 60;
  int targetTimeInMinutes = -1;
  int actTimeMinutes = int.parse(hour) * 60 + int.parse(minute);
  if (ampm == AMPM.pm){
    actTimeMinutes += minutesIn12Hrs;
  }

  int age = await userManagement.getAge();

  if (age < 6){
    return "You are $age years old. Must be at least 6 to use this tool.";
  }else if(age <= 12){
    sleepNeededMinutes = 60 * 10;
  }else if (age <= 18){
    sleepNeededMinutes = 60 * 9;
  }else{
    sleepNeededMinutes = 60 * 7;
  }

  if (choice == Options.wakeAt){
    command = "Go to bed at";
    targetTimeInMinutes = actTimeMinutes - sleepNeededMinutes;
  }else{
    command = "Wake up at at";
    targetTimeInMinutes = actTimeMinutes + sleepNeededMinutes;
  }



  targetTimeInMinutes%=minutesInDay;

  int minuteTarget = targetTimeInMinutes % 60;
  double hourTargetDouble = (targetTimeInMinutes - minuteTarget) / 60;
  int hourTarget = hourTargetDouble.round();

  if (hourTarget > 12){
    hourTarget-=12;
    ampmStr = "PM";
  }

  if (hourTarget == 0){
    hourTarget = 12;
  }

  if (minuteTarget < 10){
    result = "$command $hourTarget:0$minuteTarget $ampmStr";

  }else{
    result = "$command $hourTarget:$minuteTarget $ampmStr";
  }




  return result;

}