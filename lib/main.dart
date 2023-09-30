import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rated/firebase_options.dart';
import 'package:rated/providers/watchlist_provider.dart';
import 'package:rated/authentication/login_screen_control.dart';
import 'screens/home.dart';
import 'screens/watchlist.dart';
import 'screens/discover.dart';
import 'screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AppState()),
        ],
        child: App(),
      )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenControl(),
    );
  }
}


class MyApp extends StatefulWidget {
  static const title = 'RATED';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;
  final screens = [
    Home(),
    Watchlist(),
    Discover(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyApp.title,
      theme: ThemeData(
        fontFamily: 'San Francisco',
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            /// Home
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Color(0xffcb9b8c),
            ),
            /// Watchlist
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: "Watchlist",
              backgroundColor: Color(0xffcb9b8c),
            ),
            /// Discover
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Discover",
              backgroundColor: Color(0xffcb9b8c),
            ),
            /// Profile
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Color(0xffcb9b8c),
            ),
          ],
        ),
      ),
    );
  }
}