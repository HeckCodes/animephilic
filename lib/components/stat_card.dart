import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String stat;
  final dynamic value;
  const StatCard({
    super.key,
    required this.stat,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stat,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
