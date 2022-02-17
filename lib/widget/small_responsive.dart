import 'package:flutter/material.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/widget/app_text.dart';

class SmallResponsiveButton extends StatelessWidget {
  double? width;
  String? text;
  SmallResponsiveButton({
    Key? key,
    this.text,
    this.width = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
              ),
              child: AppText(
                text: text,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
