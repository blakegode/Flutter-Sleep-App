import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import "package:fiveguys/enums/Colors.dart";
import '../colors/AppColors.dart';
import '../models/SleepLog.dart';

class SleepLogEntryForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  final Function(SleepLog sleepLog) onSubmit;

  final SleepLog sleepLog;

  SleepLogEntryForm({super.key, required this.onSubmit, required this.sleepLog});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap with SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'stress',
                maxLines: 8,
                initialValue: sleepLog.stressText,
                decoration: const InputDecoration(labelText: 'Stress for the day?'),
              ),
              FormBuilderSlider(
                name: 'stressLevel',
                decoration: const InputDecoration(labelText: 'How much do you think stress affected your sleep?'),
                min: 0,
                max: 10,
                activeColor: AppColors.primaryColor,
                initialValue: sleepLog.stressLevel,
                divisions: 10,
                onChanged: (value) {
                  // Handle slider value changes
                },
              ),
              FormBuilderTextField(
                name: 'text',
                maxLines: 4,
                initialValue: sleepLog.text,
                decoration: const InputDecoration(labelText: 'How did you sleep?'),
                // validator: FormBuilderValidators.compose([
                //   FormBuilderValidators.required(),
                // ]),
              ),
              FormBuilderSlider(
                name: 'previousDaysActivityLevel',
                decoration: const InputDecoration(labelText: 'How energetic were you feeling yesterday?'),
                min: 0,
                max: 10,
                activeColor: AppColors.primaryColor,
                initialValue: sleepLog.previousDaysActivityLevel,
                divisions: 10,
                onChanged: (value) {
                  // Handle slider value changes
                },
              ),
              FormBuilderSlider(
                name: 'currentDaysActivityLevel',
                decoration: const InputDecoration(labelText: 'How energetic are you feeling today?'),
                min: 0,
                max: 10,
                activeColor: AppColors.primaryColor,
                initialValue: sleepLog.currentDaysActivityLevel,
                divisions: 10,
                onChanged: (value) {
                  // Handle slider value changes
                },
              ),
              FormBuilderSlider(
                name: 'sleepQuality',
                decoration: const InputDecoration(labelText: 'How would you rate your sleep?'),
                min: 0,
                max: 10,
                activeColor: AppColors.primaryColor,
                initialValue: sleepLog.sleepQuality,
                divisions: 10,
                onChanged: (value) {
                  // Handle slider value changes
                },
              ),
              FormBuilderDateTimePicker(
                name: 'sleepTime',
                inputType: InputType.time,
                decoration: const InputDecoration(labelText: 'When did you fall asleep?'),
                initialValue: sleepLog.sleepTime,
                onChanged: (value) {
                  // Handle time selection changes
                },
              ),
              FormBuilderDateTimePicker(
                name: 'wakeTime',
                inputType: InputType.time,
                decoration: const InputDecoration(labelText: 'When did you wake up?'),
                initialValue: sleepLog.wakeTime,
                onChanged: (value) {
                  // Handle time selection changes
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.saveAndValidate();

                  sleepLog.stressText = _formKey.currentState?.value['stress'];
                  sleepLog.stressLevel = _formKey.currentState?.value['stressLevel'].toDouble();
                  sleepLog.text = _formKey.currentState?.value['text'];
                  sleepLog.previousDaysActivityLevel = _formKey.currentState?.value['previousDaysActivityLevel'].toDouble();
                  sleepLog.currentDaysActivityLevel = _formKey.currentState?.value['currentDaysActivityLevel'].toDouble();
                  sleepLog.sleepQuality = _formKey.currentState?.value['sleepQuality'].toDouble();
                  sleepLog.sleepTime = _formKey.currentState?.value['sleepTime'];
                  sleepLog.wakeTime = _formKey.currentState?.value['wakeTime'];

                  // Call the onSubmit callback with user data
                  onSubmit(sleepLog);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ), backgroundColor: appColors.black,
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: appColors.white, // Adjust icon color as needed
                    ),
                    SizedBox(width: 8), // Add spacing between icon and text
                    Text(
                      'Enter Log',
                      style: TextStyle(
                        color: appColors.white, // Adjust text color as needed
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
