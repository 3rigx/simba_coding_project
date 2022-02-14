import 'package:flutter/material.dart';
import 'package:simba_coding_project/misc/app_colors.dart';

class MyTextField extends StatelessWidget {
  final String? labText;
  TextEditingController? eventController;

  MyTextField({this.labText, @required this.eventController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        controller: eventController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labText,
          labelStyle: TextStyle(color: AppColors.textColor1),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textColor1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textColor1),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textColor1),
          ),
        ),
      ),
    );
  }
}
