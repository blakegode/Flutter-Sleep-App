import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignUpForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  final Function(String age, DateTime wakeUpTime) onSubmit;

  SignUpForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'age',
              decoration: const InputDecoration(labelText: 'What\'s your age?'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'wake_up_time',
              inputType: InputType.time,
              decoration: const InputDecoration(labelText: 'Select a preferred wake up time'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState?.saveAndValidate();
                String age = _formKey.currentState?.value['age'];
                DateTime wakeUpTime = _formKey.currentState?.value['wake_up_time'];

                // Call the onSubmit callback with user data
                onSubmit(age, wakeUpTime);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), backgroundColor: Colors.white,
                elevation: 4,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.black, // Adjust icon color as needed
                  ),
                  SizedBox(width: 8), // Add spacing between icon and text
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black, // Adjust text color as needed
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
