class AnimeFieldOptions {
  final List<String> animeFull = [
    "id",
    "title",
    "main_picture",
    "alternative_titles",
    "start_date",
    "end_date",
    "synopsis",
    "mean",
    "rank",
    "popularity",
    "num_list_users",
    "num_scoring_users",
    "nsfw",
    "genres",
    "created_at",
    "updated_at",
    "media_type",
    "status",
    "my_list_status",
    "num_episodes",
    "start_season",
    "broadcast",
    "source",
    "average_episode_duration",
    "rating",
    "studios",
    "pictures",
    "background",
    "related_anime",
    "related_manga",
    "recommendations",
    "statistics",
    "opening_themes",
    "ending_themes",
  ];

  final List<String> animeSeasonal = [
    "id",
    "title",
    "main_picture",
    "mean",
    "popularity",
    "num_list_users",
    "num_scoring_users",
    "media_type",
    "status",
  ];

  String get animeSeasonalFields => animeSeasonal.join(',');
  String get animeFullFields => animeFull.join(',');
}
