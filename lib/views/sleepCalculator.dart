
import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/presenters/sleepCalculatorLogic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/enums/SleepCalculatorOptons.dart';

import 'BaseAppBar.dart';

Options? _choices = Options.sleepAt;
AMPM? ampm = AMPM.am;

class SleepCalculator extends StatefulWidget{
  const SleepCalculator({super.key});

  @override
  State<SleepCalculator> createState() => SleepCalcState();
}

class SleepCalcState extends State<SleepCalculator> {
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  String timeDisplay = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
        // appBar: BaseAppBar(
        //   key: UniqueKey(), // Provide a unique key
        //   title: const Text('Sleep Calculator'), // Set the app bar title
        //   backgroundColor:
        //   Theme.of(context).colorScheme.inversePrimary,
        //   appBar: AppBar(), // Set the background color
        // ),
      body: Center(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(timeDisplay,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),

          ),

          ActionClass(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Flexible(child:
                TextField(
                  keyboardType: TextInputType.number,
                  controller: hourController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Hour',
                  ),
                )
                ),
                Flexible(child:
                TextField(
                  keyboardType: TextInputType.number,

                  controller: minuteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Minute',
                  ),
                )
                ),
                AmPmClass(),
              ],
            ),
          ),

          ElevatedButton(onPressed: ()async{
            String result = await getTargetTime(hourController.text, minuteController.text, _choices, ampm!);
              setState(() {
                timeDisplay = result;
              });



          }, child: const Text("Calculate", style: TextStyle(color: AppColors.accentColor),))

        ],
      ),
      )
    );
  }
}

class AmPmClass extends StatefulWidget{
  const AmPmClass({super.key});

  @override
  State<AmPmClass> createState() => AmPmRadio();
}

class AmPmRadio extends State<AmPmClass>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Radio<AMPM>(
                  value: AMPM.am,
                  groupValue: ampm,
                  onChanged: (AMPM? value) {
                    setState(() {
                      ampm = value;
                    });
                  },
                ),
                const Text("am"),
              ],
            ),
            Row(
              children: [
                Radio<AMPM>(
                  value: AMPM.pm,
                  groupValue: ampm,
                  onChanged: (AMPM? value) {
                    setState(() {
                      ampm = value;
                    });
                  },
                ),
                const Text("pm")
              ],
            )

          ],

        )


      ],
    );
  }
}

class ActionClass extends StatefulWidget{
  const ActionClass({super.key});

  @override
  State<ActionClass> createState() => ActionRadio();
}

class ActionRadio extends State<ActionClass>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<Options>(
              value: Options.wakeAt,
              groupValue: _choices,
              onChanged: (Options? value) {
                setState(() {
                  _choices = value;
                });
              },
            ),
            const Text("Wake Up At"),
            Radio<Options>(
              value: Options.sleepAt,
              groupValue: _choices,
              onChanged: (Options? value) {
                setState(() {
                  _choices = value;
                });
              },
            ),
            const Text("Go To Bed At")
          ],

        )


      ],
    );
  }
}