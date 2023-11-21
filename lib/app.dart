import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/flows/account/ui/account_detail_screen.dart';
import 'package:pa_mobile/flows/account/ui/account_screen.dart';
import 'package:pa_mobile/flows/account/ui/account_screen_volunteer.dart';
import 'package:pa_mobile/flows/account/ui/modify_profile_screen.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen_volunteer.dart';
import 'package:pa_mobile/flows/chat/chat_screen.dart';
import 'package:pa_mobile/flows/chat/chat_screen_volunteer.dart';
import 'package:pa_mobile/flows/donation/ui/donation_screen.dart';
import 'package:pa_mobile/flows/event/ui/event_calendar_screen.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';
import 'package:pa_mobile/flows/inscription/ui/register_screen.dart';
import 'package:pa_mobile/flows/inscription/ui/register_success_screen.dart';
import 'package:pa_mobile/l10n/l10n.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isLogged, required this.isVolunteer, required this.navigatorKey});

  final bool isLogged;
  final bool isVolunteer;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 2,
          color: Colors.white,
          foregroundColor: Colors.black,
        ),
        primaryColor: const Color(0xFFCB3131),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFFCB3131),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: widget.isLogged
          ? widget.isVolunteer
              ? AccountScreenVolunteer.routeName
              : AccountScreen.routeName
          : HomeScreen.routeName,
      routes: {
        AccountScreen.routeName: (context) => const AccountScreen(),
        AccountScreenVolunteer.routeName: (context) => const AccountScreenVolunteer(),
        LoginScreen.routeName: (context) => LoginScreen(),
        LoginScreenVolunteer.routeName: (context) => LoginScreenVolunteer(),
        EventScreen.routeName: (context) => const EventScreen(),
        AccountDetailsScreen.routeName: (context) => const AccountDetailsScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        ModifyProfileScreen.routeName: (context) => const ModifyProfileScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        RegisterSuccessScreen.routeName: (context) => const RegisterSuccessScreen(),
        DonationScreen.routeName: (context) => const DonationScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
        ChatVolunteerScreen.routeName: (context) => const ChatVolunteerScreen(),
      },
    );
  }
}
