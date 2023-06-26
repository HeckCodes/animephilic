import 'dart:convert';

import 'package:animephilic/authentication/authentication.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: CircleAvatar()),
          Center(
            child: Text(
              "account name",
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        http.Response response = await http.get(
          Uri.parse('https://api.myanimelist.net/v2/users/@me'),
          headers: {
            'Authorization': "Bearer ${Authentication().accessToken}",
          },
        );
        dynamic userData = jsonDecode(response.body);
        print(userData);
      }),
    );
  }
}
