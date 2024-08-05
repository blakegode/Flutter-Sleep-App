import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../colors/AppColors.dart';
import '../../models/SleepLog.dart';
import '../../presenters/SleepHistoryLogic.dart';
import '../../presenters/UserManagement.dart';

class SleepHistoryGraphPage extends StatefulWidget {
  @override
  _SleepHistoryGraphPageState createState() => _SleepHistoryGraphPageState();
}

class _SleepHistoryGraphPageState extends State<SleepHistoryGraphPage> {
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionIcon('Days', 1),
              _buildOptionIcon('Weeks', 2),
              _buildOptionIcon('Months', 3),
              _buildOptionIcon('All', 4),
            ],
          ),
          SleepQualityChart(selectedOption),
          SizedBox(height: 75,)
        ],
      ),
    );
  }

  Widget _buildOptionIcon(String type, int option) {
    bool isSelected = option == selectedOption;
    BorderRadius borderRadius;

    // Determine the border radius based on the position of the button
    if (option == 1) {
      // Far left button
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(16.0),
        bottomLeft: Radius.circular(16.0),
      );
    } else if (option == 4) {
      // Far right button
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      );
    } else {
      // Middle buttons
      borderRadius = BorderRadius.zero;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: SizedBox( // Wrap the button in a SizedBox
        width: 80, // Set fixed width
        height: 35, // Set fixed height
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.lightBlueAccent : Colors.blueGrey[800],
            borderRadius: borderRadius,
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Center( // Center the text within the button
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.blueGrey[900] : Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

}


class SleepQualityChart extends StatelessWidget {
  final int selectedOption;

  SleepQualityChart(this.selectedOption);

  @override
  Widget build(BuildContext context) {
    switch (selectedOption) {
      case 1:
        return Column(children: [
          DailySleepQualityGraph(),
          DailySleepLengthGraph(),
        ],);
      case 2:
        return Column(children: [
          WeeklySleepQualityGraph(),
          WeeklySleepLengthGraph(),
        ],);
      case 3:
        return Column(children: [
          MonthlySleepQualityGraph(),
          MonthlySleepLengthGraph(),
        ],);
      case 4:
        return Column(children: [
          AllSleepQualityGraph(),
          AllSleepLengthGraph(),
        ],);
      default:
        return Column(children: [
          SizedBox(height: 100,),
          Text("Coming Soon...", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor, fontSize: 25)),
        ],);
    }
  }
}

class DailySleepQualityGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Daily Sleep Quality", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0, // Set minimum boundary
              maximum: 10, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              LineSeries<SleepLog, String>(
                dataSource: sleepLogs,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                width: 7,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date),
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }
  
  String _getFormattedDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }
    return sleepLogs.length > 7 ? sleepLogs.sublist(sleepLogs.length - 7) : sleepLogs;
  }
}


class WeeklySleepQualityGraph extends StatelessWidget {
  SleepHistoryLogic logic = SleepHistoryLogic();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Weekly Average Sleep Quality", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0, // Set minimum boundary
              maximum: 10, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              LineSeries<SleepLog, String>(
                dataSource: sleepLogs,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                width: 7,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date),
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    DateTime endOfWeek = logic.getWeekEndDate(date);
    DateTime startOfWeek = logic.getWeekStartDate(date);
    return '${startOfWeek.month}/${startOfWeek.day}-${endOfWeek.month}/${endOfWeek.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }

    List<SleepLog> weeklyFirstEntries = [];
    DateTime previousWeekStart = DateTime(0);

    double weeklySleepQualityTotal = 0;
    double weeklyEntries = 0;

    for (SleepLog log in sleepLogs) {
      DateTime currentWeekStart = logic.getWeekStartDate(log.date);

      // Check if it's a new week
      if (currentWeekStart != previousWeekStart) {
        if (weeklyFirstEntries.isNotEmpty) {
          weeklyFirstEntries.last.sleepQuality = (weeklySleepQualityTotal / weeklyEntries);
        }

        weeklyFirstEntries.add(log);
        previousWeekStart = currentWeekStart;
        weeklySleepQualityTotal = log.sleepQuality;
        weeklyEntries = 1;
      } else {
        weeklyEntries++;
        weeklySleepQualityTotal += log.sleepQuality;
      }
    }

    if (weeklyEntries > 0) {
      double averageSleepQuality = weeklySleepQualityTotal / weeklyEntries;
      weeklyFirstEntries.last.sleepQuality = averageSleepQuality;
    }

    return weeklyFirstEntries.length > 5 ? weeklyFirstEntries.sublist(weeklyFirstEntries.length - 5) : weeklyFirstEntries;
  }

}

class DailySleepLengthGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Sleep Length", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 4,
              maximum: 12,
            ),
            series: <CartesianSeries>[
              ColumnSeries<SleepLog, String>(
                dataSource: sleepLogs,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                width: 0.5,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date), // Convert DateTime to String for x-axis
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.calculateHoursSlept(),
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }
    return sleepLogs.length > 7 ? sleepLogs.sublist(sleepLogs.length - 7) : sleepLogs;
  }
}

class WeeklySleepLengthGraph extends StatelessWidget {
  SleepHistoryLogic logic = SleepHistoryLogic();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Weekly Average Sleep Length", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 4, // Set minimum boundary
              maximum: 12, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              ColumnSeries<SleepLog, String>(
                dataSource: sleepLogs,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                width: 0.5,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date), // Convert DateTime to String for x-axis
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    DateTime endOfWeek = logic.getWeekEndDate(date);
    DateTime startOfWeek = logic.getWeekStartDate(date);
    return '${startOfWeek.month}/${startOfWeek.day}-${endOfWeek.month}/${endOfWeek.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }

    List<SleepLog> weeklyFirstEntries = [];
    DateTime previousWeekStart = DateTime(0);

    double weeklySleepQualityTotal = 0;
    double weeklyEntries = 0;

    for (SleepLog log in sleepLogs) {
      DateTime currentWeekStart = logic.getWeekStartDate(log.date);

      // Check if it's a new week
      if (currentWeekStart != previousWeekStart) {
        if (weeklyFirstEntries.isNotEmpty) {
          weeklyFirstEntries.last.sleepQuality = (weeklySleepQualityTotal / weeklyEntries);
        }

        weeklyFirstEntries.add(log);
        previousWeekStart = currentWeekStart;
        weeklySleepQualityTotal = log.calculateHoursSlept();
        weeklyEntries = 1;
      } else {
        weeklyEntries++;
        weeklySleepQualityTotal += log.calculateHoursSlept();
      }
    }

    if (weeklyEntries > 0) {
      double averageSleepQuality = weeklySleepQualityTotal / weeklyEntries;
      weeklyFirstEntries.last.sleepQuality = averageSleepQuality;
    }

    return weeklyFirstEntries.length > 5 ? weeklyFirstEntries.sublist(weeklyFirstEntries.length - 5) : weeklyFirstEntries;
  }

}

class MonthlySleepQualityGraph extends StatelessWidget {
  SleepHistoryLogic logic = SleepHistoryLogic();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Monthly Average Sleep Quality", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0, // Set minimum boundary
              maximum: 10, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              LineSeries<SleepLog, String>(
                dataSource: sleepLogs,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                width: 7,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date),
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    DateTime startOfMonth = logic.getWeekStartDate(date);
    return '${startOfMonth.month}/${startOfMonth.year%2000}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }

    List<SleepLog> monthlyFirstEntries = [];
    DateTime previousMonthStart = DateTime(0);

    double monthlySleepQualityTotal = 0;
    double monthlyEntries = 0;

    for (SleepLog log in sleepLogs) {
      DateTime currentMonthStart = logic.getMonthStartDate(log.date);

      // Check if it's a new week
      if (currentMonthStart != previousMonthStart) {
        if (monthlyFirstEntries.isNotEmpty) {
          monthlyFirstEntries.last.sleepQuality = (monthlySleepQualityTotal / monthlyEntries);
        }

        monthlyFirstEntries.add(log);
        previousMonthStart = currentMonthStart;
        monthlySleepQualityTotal = log.sleepQuality;
        monthlyEntries = 1;
      } else {
        monthlyEntries++;
        monthlySleepQualityTotal += log.sleepQuality;
      }
    }

    if (monthlyEntries > 0) {
      double averageSleepQuality = monthlySleepQualityTotal / monthlyEntries;
      monthlyFirstEntries.last.sleepQuality = averageSleepQuality;
    }

    return monthlyFirstEntries.length > 24 ? monthlyFirstEntries.sublist(monthlyFirstEntries.length - 24) : monthlyFirstEntries;
  }

}

class MonthlySleepLengthGraph extends StatelessWidget {
  SleepHistoryLogic logic = SleepHistoryLogic();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Monthly Average Sleep Length", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 4, // Set minimum boundary
              maximum: 12, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              ColumnSeries<SleepLog, String>(
                dataSource: sleepLogs,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                width: 0.5,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date), // Convert DateTime to String for x-axis
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    DateTime startOfMonth = logic.getWeekStartDate(date);
    return '${startOfMonth.month}/${startOfMonth.year%2000}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }

    List<SleepLog> monthlyFirstEntries = [];
    DateTime previousMonthStart = DateTime(0);

    double monthlySleepQualityTotal = 0;
    double monthlyEntries = 0;

    for (SleepLog log in sleepLogs) {
      DateTime currentMonthStart = logic.getMonthStartDate(log.date);

      // Check if it's a new week
      if (currentMonthStart != previousMonthStart) {
        if (monthlyFirstEntries.isNotEmpty) {
          monthlyFirstEntries.last.sleepQuality = (monthlySleepQualityTotal / monthlyEntries);
        }

        monthlyFirstEntries.add(log);
        previousMonthStart = currentMonthStart;
        monthlySleepQualityTotal = log.calculateHoursSlept();
        monthlyEntries = 1;
      } else {
        monthlyEntries++;
        monthlySleepQualityTotal += log.calculateHoursSlept();
      }
    }

    if (monthlyEntries > 0) {
      double averageSleepQuality = monthlySleepQualityTotal / monthlyEntries;
      monthlyFirstEntries.last.sleepQuality = averageSleepQuality;
    }

    return monthlyFirstEntries.length > 24 ? monthlyFirstEntries.sublist(monthlyFirstEntries.length - 24) : monthlyFirstEntries;
  }

}

class AllSleepQualityGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Daily Sleep Quality", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0, // Set minimum boundary
              maximum: 10, // Set maximum boundary
            ),
            series: <CartesianSeries>[
              LineSeries<SleepLog, String>(
                dataSource: sleepLogs,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                width: 5,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date),
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.sleepQuality,
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }
    return sleepLogs;
  }
}


class AllSleepLengthGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSleepLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is loaded successfully, return the SfCartesianChart
          List<SleepLog>? sleepLogs = snapshot.data;
          return SfCartesianChart(
            title: ChartTitle(text: "Sleep Length", textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentColor)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 4,
              maximum: 12,
            ),
            series: <CartesianSeries>[
              ColumnSeries<SleepLog, String>(
                dataSource: sleepLogs,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                width: 0.5,
                animationDuration: 200,
                color: Colors.lightBlueAccent,
                xValueMapper: (SleepLog sleepLog, _) => _getFormattedDate(sleepLog.date), // Convert DateTime to String for x-axis
                yValueMapper: (SleepLog sleepLog, _) => sleepLog.calculateHoursSlept(),
              ),
            ],
          );
        }
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Future<List<SleepLog>> _fetchSleepLogs() async {
    SleepHistoryLogic logic = SleepHistoryLogic();
    List sleepLogMapList = await logic.getSleepEntries();
    sleepLogMapList = logic.GetReversedEntries(sleepLogMapList);
    List<SleepLog> sleepLogs = [];
    for (var map in sleepLogMapList) {
      sleepLogs.add(SleepLog.fromMap(map));
    }
    return sleepLogs;
  }
}