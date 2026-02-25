import 'package:flutter/material.dart';
import 'package:genui_shopping_assistant/shopping_assistant/view/shopping_assistant_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenUI Shopping Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ShoppingAssistantPage(),
    );
  }
}
