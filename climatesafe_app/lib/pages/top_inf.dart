// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:climatesafe_app/services/api_services.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  onSelected: (String value) {
                    if (value == "Home") {
                      Navigator.pushNamed(context, '/home');
                    } else if (value == "Ajustes") {
                      Navigator.pushNamed(context, '/settings');
                    } else if (value == "Chat") {
                      Navigator.pushNamed(context, '/chat');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: "Home",
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Ajustes",
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            Text(
                              "Ajustes",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Chat",
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            Text(
                              "Chat",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfBar extends StatelessWidget {
  const InfBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Color.fromARGB(255, 205, 205, 205),
                ),
                height: 5,
                width: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
  const MessageBox({super.key, required this.onMessageSent});

  final Function onMessageSent;

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController messageController = TextEditingController();
  final ApiService apiService = ApiService();

  Future<String> _getUsername() async {
    Map<String, dynamic> userData = await apiService.getUserData();
    return userData['name'];
  }

  Future<void> sendMessage(String message) async {
    String username = await _getUsername();
    bool success = await apiService.createMessage(message, username);

    if (success) {
      messageController.clear();
      widget.onMessageSent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mensagem não enviada")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // PopUp de add(Imagens, Videos, Audios)
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Mensagem',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 24.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.send,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                String message = messageController.text;
                if (message.isNotEmpty) {
                  sendMessage(message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
