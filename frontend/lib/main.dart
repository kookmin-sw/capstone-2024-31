// import 'package:flutter/material.dart';
// import 'package:frontend/challenge/create/create_challenge_screen_fir.dart';
// import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
// import 'package:frontend/community/tab_community_screen.dart';
// import 'package:frontend/login/login_screen.dart';
// import 'package:frontend/model/controller/user_controller.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:frontend/main/main_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await initializeDateFormatting('ko_KR', null);
//
//   bool isLoggedIn = await checkIfLoggedIn();
//   FlutterNativeSplash.remove();
//   runApp(MyApp(isLoggedIn: isLoggedIn));
// }
//
// class MyApp extends StatefulWidget {
//   final bool isLoggedIn;
//
//   const MyApp({super.key, required this.isLoggedIn});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   // This widgets is the root of your application.
//   Widget build(BuildContext context) {
//     Get.put(UserController());
//
//     return ScreenUtilInit(
//         designSize: const Size(375, 844),
//         minTextAdapt: true,
//         builder: (context, child) {
//           return GetMaterialApp(
//               theme: ThemeData(primaryColor: Colors.white),
//               // navigatorObservers: <NavigatorObserver>[observer],
//               initialRoute: widget.isLoggedIn ? 'main' : 'login',
//               routes: {
//                 // SplashScreen.routeName: (context) => SplashScreen(),
//                 'login': (context) => const LoginScreen(),
//                 'main': (context) => const MainScreen(),
//                 'create_challenge': (context) => const CreateChallenge_fir(),
//                 'detail_challenge': (context) => ChallengeDetailScreen(),
//                 // 'state_challenge' : (context) => ChallengeStateScreen(),
//                 'community': (context) => const TabCommunityScreen(),
//               });
//         });
//   }
// }
//
// Future<bool> checkIfLoggedIn() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? accessToken = prefs.getString('access_token');
//
//   bool isLoggedIn = accessToken != null;
//
//   return isLoggedIn;
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
    'high_importance_channel',
    'high_importance_notification',
    importance: Importance.max,
  ));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var messageString = "";

  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
  }

  @override
  void initState() {
    getMyDeviceToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );

        setState(() {
          messageString = message.notification!.body!;
          print("Foreground 메시지 수신: $messageString");
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("메시지 내용: $messageString"),
          ],
        ),
      ),
    );
  }
}
