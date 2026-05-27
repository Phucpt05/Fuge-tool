import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';

import 'services/ai_service.dart';

// Đã thêm Global Error Handling siêu cấp vip pro
void main() {
  // Thực hiện bắt lỗi toàn cục (Global Error Handling) cho ứng dụng
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await AIService.instance.init();

    // Bắt lỗi từ Flutter UI
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('🚨 [Flutter Error]: \${details.exception}');
    };

    runApp(
      const ProviderScope(
        child: ExcelCmtApp(),
      ),
    );
  }, (error, stackTrace) {
    // Bắt các lỗi bất đồng bộ (Async Errors) không lọt vào FlutterError
    debugPrint('💥 [Async Error]: \$error');
    debugPrint('Stack trace: \$stackTrace');
  });
}

class ExcelCmtApp extends StatelessWidget {
  const ExcelCmtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhận xét đề tài',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
