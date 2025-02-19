import 'package:flutter/material.dart';
import 'package:harian/presentasion/pages/chat_ai_page.dart';

class EmergencyController {
  void openChatPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatAIPage()),
    );
  }

  void callEmergencyNumber(String number) {
    debugPrint('Calling $number...');
  }
}
