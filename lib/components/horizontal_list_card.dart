import 'package:animephilic/screens/anime_details_screen.dart';
import 'package:flutter/material.dart';

class HorizontalListCard extends StatelessWidget {
  final String title;
  final String? imageURL;
  final int animeId;
  final int mangaId;
  final bool isForAnime;
  final List<(IconData, String)> info;
  const HorizontalListCard({
    super.key,
    required this.title,
    required this.imageURL,
    required this.info,
    required this.animeId,
    required this.isForAnime,
    required this.mangaId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: InkWell(
          onTap: () {
            if (isForAnime) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailsScreen(animeId: animeId),
                ),
              );
            }
          },
          splashColor: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageURL ?? "",
                    width: 150,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/avatar.png',
                        width: 150,
                        height: 180,
                        fit: BoxFit.cover,
                      );
                    },
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
      ),
    );
  }
}
