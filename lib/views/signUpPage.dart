import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:flutter/material.dart';
import './signUpForm.dart'; // Import your SignUpForm

class SignUpPage extends StatelessWidget {
  final String userId;
  final String userPhotoURL;

  SignUpPage({required this.userId, required this.userPhotoURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SignUpForm(
        // Define the onSubmit callback function and pass it to SignUpForm
        onSubmit: (String ageString, DateTime wakeUpTime) {
          int age = int.parse(ageString);
          UserManagement userManagement = UserManagement();
          userManagement.createUser(userId, userPhotoURL, age, wakeUpTime, false);
          // Process user data here
          // Navigate back to the home page
          Navigator.pop(context);
        },
      ),
    );
  }
}

