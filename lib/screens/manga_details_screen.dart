import 'package:animephilic/components/components_export.dart';
import 'package:animephilic/database/database_export.dart';
import 'package:animephilic/helpers/helpers_exports.dart';
import 'package:animephilic/screens/image_screen.dart';
import 'package:flutter/material.dart';

class MangaDetailsScreen extends StatefulWidget {
  final int mangaId;
  const MangaDetailsScreen({
    super.key,
    required this.mangaId,
  });

  @override
  State<MangaDetailsScreen> createState() => _MangaDetailsScreenState();
}

class _MangaDetailsScreenState extends State<MangaDetailsScreen> {
  bool trimSynopsis = true;
  bool trimBackground = true;
  late Future<MangaDetails> mangaDetailsFuture;
  MangaDetails? details;

  @override
  void initState() {
    super.initState();
    // Prevents calling the future builder with every setState.
    mangaDetailsFuture = getMangaDetails(widget.mangaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga Details')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await mangaDataUpdateHandler(
            context,
            widget.mangaId,
            details?.myMangaListStatus,
            details?.numberChapters ?? 0,
            details?.numberVolumes ?? 0,
          );

          if (!context.mounted) return;

          if ((response?.statusCode ?? 0) == 200) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Data Updated'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            );
            setState(() {
              mangaDetailsFuture = getMangaDetails(widget.mangaId);
            });
          } else if (response != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error Occurred ${response.statusCode}'),
                content: Text(response.body.toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.arrow_drop_up_rounded, size: 54),
      ),
      body: FutureBuilder(
        future: mangaDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            details = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              details!.largeImage ?? "",
                              width: 150,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/avatar.png',
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details!.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.tv_rounded),
                                    const SizedBox(width: 8),
                                    Text(MangaDetails.parseMediaType(
                                        details!.mediaType)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timelapse_rounded),
                                    const SizedBox(width: 8),
                                    Text("${details!.numberChapters} Chapters"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timelapse_rounded),
                                    const SizedBox(width: 8),
                                    Text("${details!.numberVolumes} Volumes"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.podcasts_rounded),
                                    const SizedBox(width: 8),
                                    Text(MangaDetails.parseStatus(
                                        details!.status)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded),
                                    const SizedBox(width: 8),
                                    Text('${details!.mean ?? 'N/A'}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 2),
                    const SizedBox(height: 8),
                    const Text(
                      "Background",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details!.background == null || details!.background == ""
                          ? "No background available."
                          : details!.background!,
                      maxLines: trimBackground ? 4 : null,
                      overflow: TextOverflow.fade,
                    ),
                    Center(
                      child: IconButton(
                        icon: trimBackground
                            ? const Icon(Icons.keyboard_arrow_down_rounded)
                            : const Icon(Icons.keyboard_arrow_up_rounded),
                        onPressed: () {
                          setState(() {
                            trimBackground = !trimBackground;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "About",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 56,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...details!.genres.map((data) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Card(
                                    child: Center(
                                        child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(data.$2),
                                ))),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      details!.synopsis ?? "No synopsis available.",
                      maxLines: trimSynopsis ? 4 : null,
                      overflow: TextOverflow.fade,
                    ),
                    Center(
                      child: IconButton(
                        icon: trimSynopsis
                            ? const Icon(Icons.keyboard_arrow_down_rounded)
                            : const Icon(Icons.keyboard_arrow_up_rounded),
                        onPressed: () {
                          setState(() {
                            trimSynopsis = !trimSynopsis;
                          });
                        },
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Tooltip(
                          message: "Rank",
                          preferBelow: false,
                          verticalOffset: 46,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.numbers_rounded),
                                  Text("${details!.rank ?? 'N/A'}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Member",
                          preferBelow: false,
                          verticalOffset: 46,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.person_rounded),
                                  Text("${details!.numberListUsers}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Ratings",
                          preferBelow: false,
                          verticalOffset: 46,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.thumbs_up_down_rounded),
                                  Text("${details!.numberScoringUsers}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Popularity",
                          preferBelow: false,
                          verticalOffset: 46,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.celebration_rounded),
                                  Text("${details!.popularity ?? 'N/A'}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      children: [
                        TableRow(children: [
                          const Text("Synonyms"),
                          Text(details!.synonyms?.join(', ') ?? 'N/A'),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("Japanese Title"),
                          Text(details!.jaTitle ?? 'N/A'),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("English Title"),
                          Text(details!.enTitle ?? 'N/A'),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("Authors"),
                          Text(details!.authors
                              .map((e) =>
                                  "${e.lastName} ${e.firstName} (${e.role})")
                              .join(', ')),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        const TableRow(children: [
                          Divider(thickness: 2),
                          Divider(thickness: 2),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("Created At"),
                          Text(
                              "${details!.createdAt.year}-${details!.createdAt.month}-${details!.createdAt.day}"),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("State Date"),
                          Text(details!.startDate ?? 'N/A'),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("End Date"),
                          Text(details!.endDate ?? 'N/A'),
                        ]),
                        const TableRow(children: [
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                        ]),
                        TableRow(children: [
                          const Text("Rating"),
                          Text(MangaDetails.parseNsfw(details!.nsfw ?? 'N/A')),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),
                    const Text(
                      "Pictures",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: details!.pictures != null &&
                          details!.pictures!.isNotEmpty,
                      replacement: const Text("No images available"),
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: details!.pictures!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                          imageURL:
                                              details!.pictures![index].$2),
                                    ),
                                  );
                                },
                                splashColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    details!.pictures![index].$2 ?? '',
                                    width: 130,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/avatar.png',
                                        width: 130,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Related Anime",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: details!.relatedAnime.isNotEmpty,
                      replacement: const Text("No related anime available"),
                      child: SizedBox(
                        height: 270,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: details!.relatedAnime.length,
                          itemBuilder: (context, index) {
                            return HorizontalListCard(
                              animeId: details!.relatedAnime[index].id,
                              mangaId: 000,
                              isForAnime: true,
                              title: details!.relatedAnime[index].title,
                              imageURL: details!.relatedAnime[index].largeImage,
                              info: [
                                (
                                  Icons.family_restroom_rounded,
                                  details!.relatedAnime[index]
                                      .relationTypeFormatted,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Related Manga",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: details!.relatedManga.isNotEmpty,
                      replacement: const Text("No related manga available"),
                      child: SizedBox(
                        height: 270,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: details!.relatedManga.length,
                          itemBuilder: (context, index) {
                            return HorizontalListCard(
                              animeId: 000,
                              mangaId: details!.relatedManga[index].id,
                              isForAnime: false,
                              title: details!.relatedManga[index].title,
                              imageURL: details!.relatedManga[index].largeImage,
                              info: [
                                (
                                  Icons.family_restroom_rounded,
                                  MangaDetails.parseRelationType(details!
                                      .relatedManga[index]
                                      .relationTypeFormatted),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Recommendations",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: details!.recommendations.isNotEmpty,
                      replacement: const Text("No recommendations available"),
                      child: SizedBox(
                        height: 270,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: details!.recommendations.length,
                          itemBuilder: (context, index) {
                            return HorizontalListCard(
                              animeId: details!.recommendations[index].id,
                              mangaId: 000,
                              isForAnime: true,
                              title: details!.recommendations[index].title,
                              imageURL:
                                  details!.recommendations[index].largeImage,
                              info: [
                                (
                                  Icons.thumb_up_alt_rounded,
                                  details!
                                      .recommendations[index].numRecommendations
                                      .toString(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Something went extremely wrong!'));
          }
        },
      ),
    );
  }
}
