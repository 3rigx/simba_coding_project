import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    Service _service = Provider.of<Service>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            ? AppColors.mainColor
                            : AppColors.bigTextColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: AppText(
                          text: 'Register',
                          color: Colors.white,
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
                            ? AppColors.bigTextColor
                            : AppColors.mainColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: AppText(
                          text: 'Log in',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              AppText(
                text: isLogin ? 'Log in' : 'Sign Up',
                color: AppColors.textColor2,
              ),
              isLogin
                  ? Container()
                  : MyTextField(
                      passworded: false,
                      eventController: nameCont,
                      labText: "full name",
                    ),
              MyTextField(
                eventController: emailCont,
                labText: "email",
                passworded: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextField(
                  controller: passwordCont,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "password",
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
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        if (isLogin
                            ? emailCont.text != '' && passwordCont.text != ''
                            : nameCont.text != ' ' &&
                                emailCont.text != ' ' &&
                                passwordCont.text != ' ') {
                          if (isLogin) {
                            bool succes = await _service.signInWithEmail(
                                emailCont.text, passwordCont.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Loading......'),
                                duration: succes
                                    ? const Duration(seconds: 1)
                                    : const Duration(minutes: 4),
                              ),
                            );
                            if (succes) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Utils.mainAppNav.currentState!
                                  .pushNamed('/mainpage');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('User not Found. Why not Register?'),
                                  duration: const Duration(minutes: 4),
                                ),
                              );
                            }
                          } else {
                            bool succes = await _service.register(
                                emailCont.text,
                                passwordCont.text,
                                nameCont.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Loading......'),
                                duration: succes
                                    ? const Duration(seconds: 1)
                                    : const Duration(minutes: 4),
                              ),
                            );
                            if (succes) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Utils.mainAppNav.currentState!
                                  .pushNamed('/welcomepage');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('User already Exits.'),
                                  duration: const Duration(minutes: 4),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: isLogin
                                  ? AppText(
                                      text: 'Input Valid Email & Password')
                                  : AppText(
                                      text:
                                          'Input Valid Name, Email & Password'),
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
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
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
                ],
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  try {
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
      ),
    );
  }
}
