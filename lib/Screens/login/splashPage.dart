import 'package:flutter/material.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/widget/app_text.dart';

class SplashPage extends StatelessWidget {
  int? duration = 0;
  Widget? goToPage;

  SplashPage({this.duration, this.goToPage});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration!), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => this.goToPage!));
    });
    return Material(
      child: Container(
        color: AppColors.mainColor,
        alignment: Alignment.center,
        child: Stack(children: [
          Align(
            child: Center(
              child: ClipOval(
                child: Container(
                  width: 180,
                  height: 180,
                  color: AppColors.mainColor,
                  alignment: Alignment.center,
                  child: AppText(text: 'Simba Project'),
                ),
              ),
            ),
            alignment: Alignment.center,
          ),
        ]),
      ),
    );
  }
}
