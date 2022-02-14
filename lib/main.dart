import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simba_coding_project/Screens/convert/send_to/sendto_page.dart';
import 'package:simba_coding_project/Screens/login/auth.dart';
import 'package:simba_coding_project/Screens/login/splashPage.dart';
import 'package:simba_coding_project/Screens/navpages/main_page.dart';
import 'package:simba_coding_project/Screens/welcomePage.dart';
import 'package:simba_coding_project/misc/utils.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/services/transaction_service.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        Provider(
          create: (_) => Service(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionSelectionService(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: Utils.mainAppNav,
        theme: ThemeData(
          fontFamily: '',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(
                duration: 3,
                goToPage: WelcomePage(),
              ),
          '/welcomepage': (context) => WelcomePage(),
          '/mainpage': (context) => MainPage(),
          '/login': (context) => AuthPage(),
          '/sendTo': (context) => SendToPage(),
        },
      )));
}
