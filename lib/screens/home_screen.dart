import 'package:animephilic/helpers/authentication.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          children: [
            Text(Authentication().tokenType),
            Text(Authentication().expiresIn.toString()),
          ],
        ),
      ),
    );
  }
}
