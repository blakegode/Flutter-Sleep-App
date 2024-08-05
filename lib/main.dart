import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/views/SleepSheep.dart';
import 'package:fiveguys/views/signUpPage.dart';
import 'package:fiveguys/views/sleepCalendar.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/presenters/notifications.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presenters/firebase_options.dart';

// import other files in project
import 'presenters/UserManagement.dart';
import 'presenters/GoogleAuthManagement.dart';
import 'package:fiveguys/WidgetPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fiveguys/api/firebase_api.dart';
import 'package:fiveguys/views/signUpPage.dart';
// import 'package:audioplayers/audioplayers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  await firebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Unable to connect");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Sweet Dreams',
              theme: ThemeData.dark().copyWith(
                colorScheme: ThemeData.dark().colorScheme.copyWith(
                  primary: AppColors.accentColor, // Set the primary color
                  secondary: AppColors.primaryColor, // Set the secondary color
                ),
              ),
              home: const MyHomePage(title: 'Sweet Dreams'),
          );

          }
          Widget loading = MaterialApp();
          return loading;
        });


  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  UserManagement userManagement = UserManagement();


  GoogleAuthManagement googleAuthManagement = GoogleAuthManagement();
  bool isNewUser = true;
  int _tapCount = 0;
  final int _requiredTapCount = 5;
  final Duration _tapTimeout = Duration(seconds: 3);
  bool _isVisible = false;

 /* late AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    // Create the audio player.
    AudioPlayer player = AudioPlayer();
    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);
    //set source
    player.setSourceAsset('audio/sheepBaa.mp3');
  } */

  /* int _tapCount = 0;
  final int _requiredTapCount = 5;
  final Duration _tapTimeout = Duration(seconds: 3);
  bool _isVisible = false;

  late AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    // Create the audio player.
    AudioPlayer player = AudioPlayer();
    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);
    //set source
    player.setSourceAsset('audio/sheepBaa.mp3');
  } */

  @override
  Widget build(BuildContext context) {


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Adjust the right padding as needed
            child: Center(
              child: SizedBox(
                width: isNewUser?100:140, // Set a fixed width for the button
                height: 36,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    // Handle sign-in action here
                    User? user = isNewUser? await googleAuthManagement.signInWithGoogle() : await googleAuthManagement.switchAccounts();
                    String displayName = user?.displayName ?? "User";
                    String userId = user != null?user.uid:"-1";
                    String photoURL = user?.photoURL ?? "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg";
                    isNewUser = await userManagement.isNewUser(photoURL, userId, displayName);
                    setState(() {
                      // Update isNewUser and trigger UI rebuild
                      isNewUser = isNewUser;
                    });
                    if (isNewUser) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage(userPhotoURL: photoURL,userId: userId)),
                      );
                      setState(() {
                        isNewUser = false;
                      });
                    }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WidgetPage()),
                      );

                    // Fully ready for the app here
                  },
                  tooltip: 'Sign In',
                  label: Text(isNewUser?'Sign In':'Switch Account'), // Display 'Sign In' text as the label
                  icon: Icon(isNewUser?Icons.lock:Icons.swap_horiz_rounded), // Lock Icon
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set button shape
                  elevation: 4, // Increase button elevation for a more prominent appearance
                  backgroundColor: Colors.black38, // Button background color
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
        // Background Image
          Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Visibility(
              visible: !_isVisible,
              child: Image.asset(
                'assets/defaultSheep.png',
                width: 300,
                height: 300,
              ),

            ),

            FloatingActionButton.extended(
              onPressed: () async {
                if (isNewUser) {
                  // Handle sign-in action here
                  User? user = await googleAuthManagement.signInWithGoogle();
                  String displayName = user?.displayName ?? "User";
                  String userId = user != null?user.uid:"-1";
                  String photoURL = user?.photoURL ?? "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg";
                  isNewUser = await userManagement.isNewUser(photoURL, userId, displayName);
                  setState(() {
                    // Update isNewUser and trigger UI rebuild
                    isNewUser = isNewUser;
                  });
                  if (isNewUser) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage(userPhotoURL: photoURL,userId: userId)),
                    );
                    setState(() {
                      isNewUser = false;
                    });
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WidgetPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WidgetPage()),
                  );
                }


                // Fully ready for the app here
              },
              tooltip: 'Sign In',
              label: Text(isNewUser?'Sign In With Google':'Take Me To The Homepage', style: const TextStyle(fontSize: 22)), // Display 'Sign In' text as the label
              icon: Icon(isNewUser?Icons.account_circle:Icons.home), // Lock Icon
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set button shape
              elevation: 4, // Increase button elevation for a more prominent appearance
              backgroundColor: Colors.black38, // Button background color
            ),
            /*const SizedBox(height: 50),
            Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Created By:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0), // Adding space between texts
                    Text("Blake", style: TextStyle(color: Colors.white)),
                    Text("Cody", style: TextStyle(color: Colors.white)),
                    Text("Elijah", style: TextStyle(color: Colors.white)),
                    Text("Kyle", style: TextStyle(color: Colors.white)),
                    Text("Tyler", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )*/

          ],
        ),
          /*Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _tapCount++;
                      _startTimer();
                      if (_tapCount >= _requiredTapCount) {
                        _tapCount = 0;
                        _isVisible = true;
                        _playSound();
                        //_startTimer();
                      }
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Visibility(
                  visible: _isVisible,
                  child: Center(
                    child: Image.asset('assets/singingSheep.png'), // Change this line with your image path
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
      // floatingActionButton: Visibility(
      //   visible: _isVisible,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       setState(() {
      //         _isVisible = false;
      //       });
      //     },
      //     child: Icon(Icons.close),
      //   ),
      // ),
    );
  }

  void _startTimer() {
    Timer(_tapTimeout, () {
      setState(() {
        _isVisible = false;
        _tapCount = 0;
      });
    });
  }
  // Function to play sound clip
  /*void _playSound() async {
    await player.play(AssetSource('audio/sheepBaa.mp3'));
  }

   @override
  void dispose() {
    player.dispose(); // Dispose audioplayer instance
    super.dispose();
  } */
}

      // This trailing comma makes auto-formatting nicer for build methods.

