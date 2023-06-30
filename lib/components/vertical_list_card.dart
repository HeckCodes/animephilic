import 'package:flutter/material.dart';

class VerticalListCard extends StatelessWidget {
  final String title;
  final String? imageURL;
  final String status;
  final String stat1;
  final String stat2;

  const VerticalListCard({
    super.key,
    required this.title,
    required this.imageURL,
    required this.status,
    required this.stat1,
    required this.stat2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: SizedBox(
        height: 160,
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageURL != null
                      ? Image.network(
                          imageURL!,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/avatar.png',
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        status,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Divider(thickness: 2),
                      Text(stat1),
                      Text(stat2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
