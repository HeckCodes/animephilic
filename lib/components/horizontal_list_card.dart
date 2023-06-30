import 'package:flutter/material.dart';

class HorizontalListCard extends StatelessWidget {
  final String title;
  final String? imageURL;
  final String stat1;
  const HorizontalListCard({
    super.key,
    required this.title,
    required this.imageURL,
    required this.stat1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
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
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset(
                        'assets/images/avatar.png',
                        height: 180,
                        fit: BoxFit.fitHeight,
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    stat1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
