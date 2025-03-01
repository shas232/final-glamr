# final_glamr

A new Flutter project

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
Important for Creating Podfile
```flutter pub add flutter_secure_storage```
```sudo gem install cocoapods```
```flutter pub get```
```brew install ruby```
```open Runner.xcworkspace```

added paywall
https://privacy.glamr.us 





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

      25-40