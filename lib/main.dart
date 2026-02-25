import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genui_shopping_assistant/app/view/app.dart';
import 'package:genui_shopping_assistant/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
