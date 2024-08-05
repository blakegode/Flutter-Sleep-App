import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../WidgetPage.dart';
import '../colors/AppColors.dart';
import 'package:fiveguys/presenters/SleepHistoryLogic.dart';

class SleepSheep extends StatefulWidget{
  const SleepSheep({super.key});
  @override
  State<SleepSheep> createState() => SleepSheepState();
}



class SleepSheepState extends State<SleepSheep> {
  SleepHistoryLogic logic = SleepHistoryLogic();


  bool sleptToday = false;
  bool sleptWellToday = false;
  int sleepStreak = 0;
  int goodSleepStreak = 0;

  @override
  void initState() {
    super.initState();
    // Call logic.didSleepToday() here to fetch initial data
    logic.didSleepToday().then((value) => setState(() => sleptToday = value));
    logic.sleptWellToday().then((value) => setState(() => sleptWellToday = value));
    logic.getSleepStreak(false).then((value) => setState(() => sleepStreak = value));
    logic.getSleepStreak(true).then((value) => setState(() => goodSleepStreak = value));
  }

  @override
  Widget build(BuildContext context) {

    String sleptTodayResp = "error";
    String bgSrc = "";
    String streak = "$sleepStreak";
    String goodSleepResp = "You have not gotten restful sleep";
    String message = "";
    int starCount = goodSleepStreak;
    bool goldenStar = false;

    if (starCount > 3){
      starCount = 3;
      goldenStar = true;
    }

    if (sleepStreak < goodSleepStreak && sleepStreak > 0){
      message = "You did not get sufficient rest last night.";
    }else if (sleepStreak == 0){
      message = "Make sure to log last night's sleep.";
    }else{
      message = "Good job!";
    }


    if (goodSleepStreak >= 1){
      goodSleepResp = "You have gotten restful sleep lately";
    }


    if (sleptToday){
      sleptTodayResp = "You slept today!";
    }else{
      sleptTodayResp = "You did not sleep today.";
    }

    if (true){
      bgSrc = 'assets/backgrounds/pasture.jpg';
  }else{
      bgSrc = 'assets/backgrounds/badSleepBG.png';
    }
//put streak sleep sheep
    return FutureBuilder(future: logic.didSleepToday().then((sleptToday) => Scaffold(

    body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgSrc),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < starCount; i++)
                    if (goldenStar)
                      Image.asset('assets/goldenStar.png', width: 100, height: 100,)
                    else
                      Image.asset('assets/star.png', width: 50, height: 50,)
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text("Your sleep streak is $goodSleepStreak days",
                style: const TextStyle(
                    fontSize: 25.0,
                    color: AppColors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 10,
                          color: Colors.black
                      ),
                    ]
                ),
              ),
              Text(message,
                style: const TextStyle(
                    fontSize: 25.0,
                    color: AppColors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 10,
                          color: Colors.black
                      ),
                    ]
                ),
              ),
                Text(sleptTodayResp,
                style: const TextStyle(
                    fontSize: 25.0,
                    color: AppColors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black
                      ),
                    ]
                ),
                ),
              if (sleptToday)
                Image.asset(
                  'assets/defaultSheep.png',
                  width: 300,
                  height: 300,
                ),
              if (!sleptToday)
                Image.asset(
                  'assets/notsleepsheep.png',
                  width: 300,
                  height: 300,
                )
            ],
          ),
        ),
      )

      //enter here



    )),
     builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.done){
        var data = snapshot.data;
        if (data != null)
          return data;
      }
      return Column(

      );
    });
    throw UnimplementedError();
  }

}

/*floatingActionButton: FloatingActionButton.extended(
        label: Text('Widget Page', style: const TextStyle(fontSize: 22)), // Display 'Sign In' text as the label
        icon: const Icon(Icons.home), // Lock Icon
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set button shape
        elevation: 4, // Increase button elevation for a more prominent appearance
        backgroundColor: Colors.black38,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WidgetPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/