import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String? imageURL;
  const ImageScreen({
    super.key,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Image"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          imageURL ?? '',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/avatar.png',
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
