import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    Service _service = Provider.of<Service>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 100,
              ),
              child: AppLargeText(
                text: 'Welcome',
                color: AppColors.bigTextColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 40,
              ),
              height: 400,
              child: AppLargeText(
                text: 'Simba Project by Greendly',
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            InkWell(
              onTap: () async {
                bool succes = await _service.signInWithGoogle();

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
            AppText(
              text: 'or Register',
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Utils.mainAppNav.currentState!.pushNamed('/login');
              },
              child: ResponsiveButton(
                isResponsive: true,
                text: 'Register / Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
