class SleepLog {
  DateTime date;
  String text; //how did you sleep log
  String stressText;
  double stressLevel;
  double previousDaysActivityLevel;
  double currentDaysActivityLevel;
  double sleepQuality;
  DateTime sleepTime;
  DateTime wakeTime;

  // Constructor
  SleepLog(
      this.date,
      this.text,
      this.stressText,
      this.stressLevel,
      this.previousDaysActivityLevel,
      this.currentDaysActivityLevel,
      this.sleepQuality,
      this.sleepTime,
      this.wakeTime,
      );

  double calculateHoursSlept() {
    if (wakeTime.isBefore(sleepTime)) {
      Duration durationTillMidnight = DateTime(sleepTime.year, sleepTime.month, sleepTime.day + 1)
          .difference(sleepTime);
      Duration durationFromMidnight = wakeTime.difference(DateTime(wakeTime.year, wakeTime.month, wakeTime.day));
      double hoursSlept = (durationTillMidnight.inMinutes + durationFromMidnight.inMinutes) / 60.0;
      return hoursSlept;
    } else {
      Duration durationSlept = wakeTime.difference(sleepTime);
      double hoursSlept = durationSlept.inMinutes / 60.0;
      return hoursSlept;
    }
  }


  // Method to convert SleepLog to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'text': text,
      'stressText': stressText,
      'stressLevel': stressLevel,
      'previousDaysActivityLevel': previousDaysActivityLevel,
      'currentDaysActivityLevel': currentDaysActivityLevel,
      'sleepQuality': sleepQuality,
      'sleepTime': sleepTime,
      'wakeTime': wakeTime,
    };
  }

  // Static method to create a SleepLog instance from a map
  static SleepLog fromMap(Map<String, dynamic> map) {
    return SleepLog(
      map['date'].toDate(),
      map['text'],
      map['stressText'],
      map['stressLevel'],
      map['previousDaysActivityLevel'],
      map['currentDaysActivityLevel'],
      map['sleepQuality'],
      map['sleepTime'].toDate(),
      map['wakeTime'].toDate(),
    );
  }
}
