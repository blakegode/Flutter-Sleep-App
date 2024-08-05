import 'package:fiveguys/colors/AppColors.dart';
import 'package:fiveguys/presenters/UserManagement.dart';
import 'package:flutter/material.dart';
import 'package:fiveguys/enums/Colors.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final Color backgroundColor;

  const BaseAppBar({
    required Key key,
    required this.title,
    required this.appBar,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _BaseAppBarState createState() => _BaseAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _BaseAppBarState extends State<BaseAppBar> {
  UserManagement userManagement = UserManagement();
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    print(userManagement.getUserPhotoURL());
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: widget.title,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Center(
            child: SizedBox(
              width: 115,
              height: 36,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  // Navigate back to home page
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  setState(() {

                  });
                },
                tooltip: 'Sign In',
                label: Text('Signed In'),
                icon: CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(userManagement.getUserPhotoURL()),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                backgroundColor: Colors.black38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
