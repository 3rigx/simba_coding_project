import 'package:flutter/material.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/misc/utils.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/widget/app_large_text.dart';
import 'package:simba_coding_project/widget/app_text.dart';
import 'package:simba_coding_project/widget/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Service? _service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            ListTile(
              title: AppLargeText(
                text: 'Welcome',
                color: AppColors.bigTextColor,
              ),
            ),
            Container(
                height: 250,
                child: AppText(
                  text: 'Simba Project',
                )),
            InkWell(
              onTap: () async {
                bool succes = await _service!.signInWithGoogle();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CircularProgressIndicator(),
                    duration: succes
                        ? const Duration(seconds: 1)
                        : const Duration(minutes: 3),
                  ),
                );

                if (succes) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Utils.mainAppNav.currentState!.pushNamed('/mainpage');
                }
              },
              child: ResponsiveButton(
                isResponsive: true,
                text: 'Login with Google',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: AppText(
                text: 'or Register',
              ),
              subtitle: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Utils.mainAppNav.currentState!.pushNamed('/login');
                    },
                    child: ResponsiveButton(
                      isResponsive: true,
                      text: '>>>>>>',
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
