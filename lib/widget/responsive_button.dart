import 'package:flutter/material.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/widget/app_text.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;
  String? text;
  ResponsiveButton(
      {Key? key, this.text, this.width = 120, this.isResponsive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: isResponsive == true ? double.maxFinite : width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: Row(
          mainAxisAlignment: isResponsive == true
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            isResponsive == true
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: AppText(
                      text: text,
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
