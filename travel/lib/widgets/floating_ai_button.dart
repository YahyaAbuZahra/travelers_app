import 'package:flutter/material.dart';
import 'ai_chat_widget.dart';

class FloatingAIButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: FloatingActionButton(
        heroTag: "ai_assistant",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIChatWidget(),
              fullscreenDialog: true,
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.smart_toy, color: Colors.white),
      ),
    );
  }
}
