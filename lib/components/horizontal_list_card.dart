import 'package:flutter/material.dart';

class HorizontalListCard extends StatelessWidget {
  final String title;
  final String? imageURL;
  final List<(IconData, String)> info;
  const HorizontalListCard({
    super.key,
    required this.title,
    required this.imageURL,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageURL != null
                    ? Image.network(
                        imageURL!,
                        height: 180,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/avatar.png',
                        height: 180,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(thickness: 2, endIndent: 16, indent: 16),
            Wrap(
              direction: Axis.horizontal,
              children: [
                ...info.map(
                  (data) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          data.$1,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          data.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
