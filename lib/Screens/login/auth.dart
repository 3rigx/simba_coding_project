import 'package:flutter/material.dart';
import 'package:simba_coding_project/Screens/login/widgets/my_text_field.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/misc/utils.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/widget/app_text.dart';
import 'package:simba_coding_project/widget/responsive_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  bool isCheck = false;
  bool isLogin = false;
  bool isSignup = true;

  String? name, email, password;
  Service? _service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isSignup = true;
                      isLogin = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: isLogin == true
                          ? AppColors.mainTextColor
                          : AppColors.bigTextColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: AppText(
                        text: 'Register',
                        color: AppColors.textColor1,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSignup = false;
                      isLogin = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: isLogin
                          ? AppColors.mainTextColor
                          : AppColors.bigTextColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: AppText(
                        text: 'Log in',
                        color: AppColors.textColor1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: AppText(
                text: isLogin ? 'Log in' : 'Sign Up',
                color: AppColors.textColor2,
              ),
            ),
            isLogin
                ? Container()
                : MyTextField(
                    eventController: nameCont,
                    labText: "full name",
                  ),
            MyTextField(
              eventController: emailCont,
              labText: "email",
            ),
            MyTextField(
              labText: "password",
              eventController: passwordCont,
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: InkWell(
                onTap: () async {
                  try {
                    if (isLogin
                        ? emailCont.text != '' && passwordCont.text != ''
                        : nameCont.text != ' ' &&
                            emailCont.text != ' ' &&
                            passwordCont.text != ' ') {
                      if (isLogin) {
                        bool succes = await _service!
                            .signInWithEmail(emailCont.text, passwordCont.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CircularProgressIndicator(),
                            duration: succes
                                ? const Duration(seconds: 1)
                                : const Duration(minutes: 4),
                          ),
                        );
                        if (succes) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Utils.mainAppNav.currentState!.pushNamed('/mainpage');
                        }
                      } else {
                        bool succes = await _service!.register(
                            emailCont.text, passwordCont.text, nameCont.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CircularProgressIndicator(),
                            duration: succes
                                ? const Duration(seconds: 1)
                                : const Duration(minutes: 4),
                          ),
                        );
                        if (succes) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Utils.mainAppNav.currentState!
                              .pushNamed('/welcomepage');
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: isLogin
                              ? AppText(text: 'Input Valid Email & Password')
                              : AppText(
                                  text: 'Input Valid Name, Email & Password'),
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AppText(text: '$e'),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  }
                },
                child: ResponsiveButton(
                  text: isLogin ? "Log in" : "Sing up",
                  isResponsive: true,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                try {
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
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(text: '$e'),
                      action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              },
              child: ResponsiveButton(
                text: 'Sign with Google',
                isResponsive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
