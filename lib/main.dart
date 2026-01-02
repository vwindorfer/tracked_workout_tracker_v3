import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/screens.dart';
import 'services/database_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await DatabaseService.initialize();

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()..loadData()),
      ],
      child: const TrackedApp(),
    ),
  );
}

class TrackedApp extends StatelessWidget {
  const TrackedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // Update system UI based on theme
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: themeProvider.isDarkMode
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarColor: themeProvider.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            systemNavigationBarIconBrightness: themeProvider.isDarkMode
                ? Brightness.light
                : Brightness.dark,
          ),
        );

        return MaterialApp(
          title: 'tracked',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const AppShell(),
        );
      },
    );
  }
}
