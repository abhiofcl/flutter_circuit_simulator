import 'package:circuit_simulator/pages/chatbot/chat_page.dart';
import 'package:circuit_simulator/pages/tests/listtest.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyMenu())),
                child: Container(
                  decoration: BoxDecoration(color: Colors.blue[400]),
                  width: 200,
                  height: 200,
                  child: const Center(child: Text("Start Simulating")),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage())),
                child: Container(
                  decoration: BoxDecoration(color: Colors.blue[500]),
                  width: 200,
                  height: 200,
                  child: const Center(child: Text("Start Chat Bot")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
