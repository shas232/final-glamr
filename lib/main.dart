import 'package:flutter/material.dart';
import 'screens/SubscriptionScreen.dart';
import 'screens/camera_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/purchases_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await PurchasesService.init();  // Initialize RevenueCat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glamr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: PurchasesService.checkProAccess(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // If user has pro access, go directly to camera
          if (snapshot.data == true) {
            return CameraScreen();
          }
          
          // Otherwise show normal onboarding flow
          return SubscriptionScreen();
        },
      ),
    );
  }
}
