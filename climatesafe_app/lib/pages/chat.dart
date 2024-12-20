// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:climatesafe_app/services/api_services.dart';
import 'package:climatesafe_app/pages/top_inf.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> messages = [];
  String loggedUser = '';
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadLoggedUser();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLoggedUser() async {
    Map<String, dynamic> userData = await apiService.getUserData();
    setState(() {
      loggedUser = userData['name'];
    });
  }

  Future<void> _loadMessages() async {
    List<Map<String, dynamic>> loadedMessages =
        await apiService.getAllMessages();
    setState(() {
      messages = loadedMessages;
    });
  }

  void _refreshMessages() {
    _loadMessages();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;
    double bottomHeight = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: width, height: topHeight, child: const TopBar()),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isOwnMessage = message['username'] == loggedUser;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                      left: isOwnMessage ? width * 0.5 : 0,
                      right: !isOwnMessage ? width * 0.5 : 0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isOwnMessage
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                          topRight: isOwnMessage
                              ? const Radius.circular(0)
                              : const Radius.circular(20),
                          topLeft: !isOwnMessage
                              ? const Radius.circular(0)
                              : const Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isOwnMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['username'],
                            style: TextStyle(
                              color: isOwnMessage
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['message'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            width: width,
            height: bottomHeight,
            child: MessageBox(
              onMessageSent: _refreshMessages,
            ),
          ),
        ],
      ),
    );
  }
}
