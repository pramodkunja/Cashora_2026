import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'core/services/storage_service.dart';
import 'core/services/network_service.dart';
import 'core/services/auth_service.dart';
import 'data/repositories/auth_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => NetworkService().init());
  Get.lazyPut(() => AuthRepository(Get.find<NetworkService>()));
  await Get.putAsync(() => AuthService(Get.find<AuthRepository>(), Get.find<StorageService>()).init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Petty Cash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F9FA), // Off-white bluish bg
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
