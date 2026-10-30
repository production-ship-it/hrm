import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrms/ui/intro/splash_screen.dart';

import 'common/common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.themeModeNotifier,
          builder: (context, currentMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'HRMS App',
              themeMode: currentMode,

              // Light Theme configuration
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF8FAFC),
                cardColor: Colors.white,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFE50914),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),

              // Dark Theme configuration
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF0F0F0F),
                cardColor: const Color(0xFF1E1E1E),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFE50914),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),

              home: const SplashScreen(),

              // Combine EasyLoading builder withScreenUtil / Theme builder
              builder: (context, child) {
                child = EasyLoading.init()(context, child);
                return child;
              },
            );
          },
        );
      },
    );
  }
}