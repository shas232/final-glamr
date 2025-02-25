import 'package:flutter/material.dart';
import 'screens/SubscriptionScreen.dart';
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
      routes: {
        '/': (context) => SubscriptionScreen(),
      },
    );
  }
}
