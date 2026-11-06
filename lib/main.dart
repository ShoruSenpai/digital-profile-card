import 'package:flutter/material.dart';
import 'pages/profile_page.dart';
import 'pages/onboarding_page.dart';
import 'services/pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await PrefService.init();
  await prefs.increaseOpenCount(); 
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final PrefService prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        return MaterialApp(
          title: 'Kartu Profil Digital',
          debugShowCheckedModeBanner: false,
          
          theme: ThemeData(
            colorSchemeSeed: prefs.themeColor,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: prefs.themeColor,
            brightness: Brightness.dark,
          ),
          themeMode: prefs.themeMode, 

          home: prefs.hasSeenOnboarding
              ? ProfilePage(prefs: prefs)
              : OnboardingPage(prefs: prefs),
        );
      },
    );
  }
}