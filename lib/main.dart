import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/onBoarding/name_page.dart';
import 'package:personal_finance_management/service/AppChecker.dart';
import 'package:personal_finance_management/service/localNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'pages/Login & SignUp/social_login.dart';

int? isViewed;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     final id = inputData?['id'] as int;
//     final title = inputData?['title'] as String?;
//     final body = inputData?['body'] as String?;
//     final payload = inputData?['payload'] as String?;
//     final reminderType = inputData?['reminderType'] as String?;
//     final reminderData = inputData?['reminderData'] as Map<String, dynamic>;
//     final scheduledDateTime = inputData?['scheduledDateTime'] as String;
//
//     final NotificationService notificationService = NotificationService();
//
//     switch (reminderType) {
//       case 'Daily':
//         notificationService.scheduleRecurringNotification(
//           id: id,
//           title: title!,
//           body: body!,
//           payload: payload!,
//           scheduledDateTime: DateTime.parse(scheduledDateTime),
//         );
//         break;
//       case 'Weekly':
//         notificationService.scheduleWeeklyNotification(
//           id: id,
//           title: title!,
//           body: body!,
//           payload: payload!,
//           dayOfWeek: reminderData['dayOfWeek'] as String,
//           scheduledTime: DateTime.parse(scheduledDateTime),
//         );
//         break;
//       case 'Monthly':
//         notificationService.scheduleMonthlyNotification(
//           id: id,
//           title: title!,
//           body: body!,
//           payload: payload!,
//           dayOfMonth: reminderData['dayOfMonth'] as int,
//           scheduledTime: DateTime.parse(scheduledDateTime),
//         );
//         break;
//       case 'Yearly':
//         notificationService.scheduleYearlyNotification(
//           id: id,
//           title: title!,
//           body: body!,
//           payload: payload!,
//           monthOfYear: reminderData['monthOfYear'] as int,
//           dayOfMonth: reminderData['dayOfMonth'] as int,
//           scheduledTime: DateTime.parse(scheduledDateTime),
//         );
//         break;
//       default:
//       // Handle unsupported reminder type
//     }
//
//     return Future.value(true);
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationManager().initNotification();
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await MySharedPreferences.firstRunCheck();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('OnBoardPage');
  tz.initializeTimeZones();
  await Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  MyAppState() {
    MySharedPreferences.instance.getBooleanValue("isfirstRun").then((value) => setState(() {
          isLoggedIn = value;
        }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
    // Noti.initialize(flutterLocalNotificationsPlugin);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      title: 'PFM',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xffFFB62D),
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 13.0, fontFamily: 'Gilroy Medium', color: Color(0xff3a3a3a)),
          titleMedium: TextStyle(fontSize: 18.0, fontFamily: 'Gilroy Medium'),
          titleLarge: TextStyle(fontSize: 25.0, fontFamily: 'Gilroy Bold', color: Color(0xff3a3a3a)),
          headlineMedium: TextStyle(fontSize: 12.0, fontFamily: 'Gilroy Medium', color: Color(0xffFFE3DE)),
        ),
      ),
      // home:TestApp(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (kDebugMode) {
              print('isFirstLaunch: $isLoggedIn');
            }
            // return isViewed != 0 ? const OnBoardPage() : const HomePage();
            return isLoggedIn ? HomePage() : const NamePageOnboard();
          } else {
            // return const LoginPage();
            return const SocialLoginPage();
          }
        },
      ),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void initialization() async {
    var status = await Permission.notification.request();
    // print('Status: ${status}');
    if (Platform.isAndroid) {
      if (status.isGranted) {
        // Permission is granted
        await Future.delayed(const Duration(seconds: 1));
        FlutterNativeSplash.remove();
      } else if (status.isDenied) {
        // openAppSettings();
        // Permission is denied
      } else if (status.isPermanentlyDenied) {
        // Permission is permanently denied, take the user to app settings
        openAppSettings();
      }
    } else if (Platform.isIOS) {
      await Future.delayed(const Duration(seconds: 1));
      FlutterNativeSplash.remove();
    }
  }
}
