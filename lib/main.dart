import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './providers/auth.dart';
import '../providers/save_pet.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: _providers, child: const MyApp()));
}

List<SingleChildWidget> _providers = [
  ChangeNotifierProvider<Auth>(create: (_) => Auth()),
  ChangeNotifierProvider<SavePet>(create: (_) => SavePet())
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet App',
        theme: ThemeData(
            // primarySwatch: const Color.fromARGB(255, 238, 123, 161),
            // primaryColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: auth.isAuth
            ? const HomeScreen()
            : FutureBuilder(
                future: auth.autoLogin(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen(),
              ),
      ),
    );
  }
}
