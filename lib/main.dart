import 'package:flutter/material.dart';
import 'package:highlight_nav_bar/spotlight_item.dart';
import 'package:highlight_nav_bar/spotlight_nav_bar.dart';
import 'package:one_fit_man/screens/home/home_screen.dart';
import 'package:one_fit_man/screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'One Fit Man',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: SpotlightNavBar(items: [
          SpotlightItem(
              title: 'Home', screen: const HomeScreen(), icon: Icons.home),
          SpotlightItem(
              title: 'Settings',
              screen: const SettingsScreen(),
              icon: Icons.settings),
        ]));
  }
}
