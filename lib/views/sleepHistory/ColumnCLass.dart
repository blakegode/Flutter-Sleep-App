

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../enums/Colors.dart';


class SleepTile extends StatefulWidget{

  var dateFormat;
  var sleepQuality;
  var diff;
  var message;
  var sleepTime;
  var wakeTime;

  SleepTile(this.dateFormat, this.sleepQuality, this.diff, this.message, this.sleepTime, this.wakeTime,  {super.key});

  @override
  ColumnClassState createState() => ColumnClassState();
}

class ColumnClassState extends State<SleepTile>{

  var dateFormat;
  var sleepQuality;
  var diff;
  var message;
  var sleepTime;
  var wakeTime;
  Color c = appColors.blue;

  @override
  void initState() {
    super.initState();
    dateFormat = widget.dateFormat;
    sleepQuality = widget.sleepQuality;
    diff = widget.diff;
    message = widget.message;
    sleepTime = widget.sleepTime;
    wakeTime = widget.wakeTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: appColors.black,
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ), height: 100.0,

      child: InkWell(
        child: Stack(

            children: [

              Positioned(
                  bottom: 20,
                  left: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Date: $dateFormat | Sleep $diff")
                    ],
                  )
              ),
              Positioned(
                  top: 20,
                  left: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sleep Quality: $sleepQuality")
                    ],
                  )
              ),

              if (message.length > 0)
                Positioned(
                    left: 20,
                    top: 30,
                    child: Icon(Icons.message)
                )
            ]
        ),


        onTap: () {
          showDialog(context: context,
              builder: (BuildContext context)=>AlertDialog(
                  backgroundColor: Colors.indigo,
                  title: Text("Summary"),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Text("Date: $dateFormat"),
                        Text("Sleep Duration: $diff"),
                        Text("Sleep Quality: $sleepQuality"),
                        Text("From $sleepTime to $wakeTime"),
                        if (message.length > 0)
                          Text("Message: $message"),

                      ],

                    ),
                  ) ));
        },
      ),


    );
  }

}

