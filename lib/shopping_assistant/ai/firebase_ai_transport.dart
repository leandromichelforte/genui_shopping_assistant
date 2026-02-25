import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:genui_shopping_assistant/shopping_assistant/catalog/shopping_catalog.dart';
import 'package:genui_shopping_assistant/shopping_assistant/prompt/shopping_prompt.dart';

/// Creates and configures a [FirebaseAiContentGenerator] backed by Firebase AI
/// (Gemini 2.5 Flash).
///
/// The catalog schema is automatically sent to the AI via tool definitions.
/// History and state management are handled by [GenUiConversation].
FirebaseAiContentGenerator buildFirebaseAiContentGenerator() {
  return FirebaseAiContentGenerator(
    catalog: shoppingCatalog,
    systemInstruction:
        shoppingSystemInstructions + GenUiPromptFragments.basicChat,
  );
}
