
import 'package:fiveguys/enums/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ColumnCLass.dart';
import 'SleepHistoryPage.dart';

class SleepHistoryListPage extends StatefulWidget{

  @override
  State<SleepHistoryListPage> createState() => SleepHistoryListState();


}

class SleepHistoryListState extends State<SleepHistoryListPage> {


  final Future<List> content = logic.getRows();

  Future<Column> getColumn() async {
    List myList = await content;
    List<SleepTile> rowList = [];
    for (Map m in myList){
      final date = m["dateFormat"];
      final sleepQuality = m["sleepQuality"];
      final message = m["message"];
      final sleepDifference = m["sleepDifference"];
      final sleepTime = m["sleepTime"];
      final wakeTime = m["wakeTime"];
      SleepTile c = SleepTile(date, sleepQuality, sleepDifference, message, sleepTime, wakeTime);

      rowList.add(c);
    }
    Column c = Column(
      children: [
        for (SleepTile c in rowList)
          c
      ],
    );

    return c;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getColumn(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data;
            if (data != null)
              return data;
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: appColors.indigo,

                ),]
          ) ;

        });
  }
}


