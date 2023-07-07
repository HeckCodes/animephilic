class RelatedItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final String relationType;
  final String relationTypeFormatted;

  RelatedItem({
    required this.id,
    required this.title,
    required this.mediumImage,
    required this.largeImage,
    required this.relationType,
    required this.relationTypeFormatted,
  });

  factory RelatedItem.fromMap(Map<String, dynamic> map) {
    return RelatedItem(
      id: map['node']['id'] as int,
      title: map['node']['title'] as String,
      mediumImage: map['node']['main_picture'] != null ? map['node']['main_picture']['medium'] : null,
      largeImage: map['node']['main_picture'] != null ? map['node']['main_picture']['large'] : null,
      relationType: map['relation_type'] as String,
      relationTypeFormatted: map['relation_type_formatted'] as String,
    );
  }
}

class RecommendationItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final int numRecommendations;

  RecommendationItem({
    required this.id,
    required this.title,
    required this.mediumImage,
    required this.largeImage,
    required this.numRecommendations,
  });

  factory RecommendationItem.fromMap(Map<String, dynamic> map) {
    return RecommendationItem(
      id: map['node']['id'] as int,
      title: map['node']['title'] as String,
      mediumImage: map['node']['main_picture'] != null ? map['node']['main_picture']['medium'] : null,
      largeImage: map['node']['main_picture'] != null ? map['node']['main_picture']['large'] : null,
      numRecommendations: map['num_recommendations'] as int,
    );
  }
}

class StatisticsItem {
  final int numberListUsers;
  final int watching;
  final int complete;
  final int onHold;
  final int dropped;
  final int planToWatch;

  StatisticsItem({
    required this.numberListUsers,
    required this.watching,
    required this.complete,
    required this.onHold,
    required this.dropped,
    required this.planToWatch,
  });

  factory StatisticsItem.fromMap(Map<String, dynamic> map) {
    return StatisticsItem(
      numberListUsers: map['num_list_users'] as int,
      watching: int.parse(map['status']['watching'].toString()),
      complete: int.parse(map['status']['completed'].toString()),
      onHold: int.parse(map['status']['on_hold'].toString()),
      dropped: int.parse(map['status']['dropped'].toString()),
      planToWatch: int.parse(map['status']['plan_to_watch'].toString()),
    );
  }
}

class MyListStatus {
  final String myStatus; // Parse
  final int myScore;
  final int numberEpWatched;
  final bool isRewatching;
  final DateTime updatedAt;

  MyListStatus({
    required this.myStatus,
    required this.myScore,
    required this.numberEpWatched,
    required this.isRewatching,
    required this.updatedAt,
  });

  factory MyListStatus.fromMap(Map<String, dynamic> map) {
    return MyListStatus(
      myStatus: map['status'] as String,
      myScore: map['score'] as int,
      numberEpWatched: map['num_episodes_watched'] as int,
      isRewatching: map['is_rewatching'] as bool,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class AnimeDetails {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final List<String>? synonyms;
  final String? enTitle;
  final String? jaTitle;
  final String? startDate;
  final String? endDate;
  final String? synopsis;
  final double? mean;
  final int? rank;
  final int? popularity;
  final int numberListUsers;
  final int numberScoringUsers;
  final String? nsfw; // Parse
  final List<(int, String)> genres;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String mediaType; // Parse
  final String status; // Parse
  final MyListStatus? myListStatus;
  final int numberEpisodes;
  final (int, String)? startSeason;
  final (String, String)? broadcast;
  final String? source; // Parse
  final int? averageEpDurationInSec;
  final String? rating; // Parse
  final List<(int, String)> studios;
  final List<(String?, String?)>? pictures;
  final String? background;
  final List<RelatedItem> relatedAnime;
  final List<RelatedItem> relatedManga;
  final StatisticsItem? statistics;
  final List<RecommendationItem> recommendations;
  final List<String>? openingThemes;
  final List<String>? endingThemes;

  AnimeDetails({
    required this.id,
    required this.title,
    required this.mediumImage,
    required this.largeImage,
    required this.synonyms,
    required this.enTitle,
    required this.jaTitle,
    required this.startDate,
    required this.endDate,
    required this.synopsis,
    required this.mean,
    required this.rank,
    required this.popularity,
    required this.numberListUsers,
    required this.numberScoringUsers,
    required this.nsfw,
    required this.genres,
    required this.createdAt,
    required this.updatedAt,
    required this.mediaType,
    required this.status,
    required this.myListStatus,
    required this.numberEpisodes,
    required this.startSeason,
    required this.broadcast,
    required this.source,
    required this.averageEpDurationInSec,
    required this.rating,
    required this.studios,
    required this.pictures,
    required this.background,
    required this.relatedAnime,
    required this.relatedManga,
    required this.statistics,
    required this.recommendations,
    required this.openingThemes,
    required this.endingThemes,
  });

  static String parseNsfw(String value) {
    switch (value) {
      case 'white':
        return 'White: This is safe for work';
      case 'gray':
        return 'Grey: This may be not safe for work';
      case 'black':
        return 'Black: This is not safe for work';
      default:
        return 'Undefined';
    }
  }

  static String parseMediaType(String value) {
    switch (value) {
      case 'tv':
        return 'TV';
      case 'ova':
        return 'OVA';
      case 'movie':
        return 'Movie';
      case 'special':
        return 'Special';
      case 'ona':
        return 'ONA';
      case 'music':
        return 'Music';
      default:
        return 'Unknown';
    }
  }

  static String parseStatus(String status, {bool short = false}) {
    switch (status) {
      case 'watching':
        return "Watching";
      case 'completed':
        return "Completed";
      case 'on_hold':
        return "On Hold";
      case 'dropped':
        return "Dropped";
      case 'plan_to_watch':
        return short ? "PTW" : "Plan to Watch";
      case 'finished_airing':
        return short ? "FA" : "Finished Airing";
      case 'currently_airing':
        return short ? "CA" : "Currently Airing";
      case 'not_yet_aired':
        return short ? "NYA" : "Not Yet Aired";
      default:
        return short ? 'N/A' : "Undefined State";
    }
  }

  static String parseSource(String value) {
    switch (value) {
      case 'other':
        return "Other";
      case 'original':
        return "Original";
      case 'manga':
        return "Manga";
      case '4_koma_manga':
        return "4 Koma Manga";
      case 'web_manga':
        return "Web Manga";
      case 'digital_manga':
        return "Digital Manga";
      case 'Novel':
        return "Novel";
      case 'light_novel':
        return "Light Novel";
      case 'visual_novel':
        return "Visual Novel";
      case 'game':
        return "Game";
      case 'card_game':
        return "Card Game";
      case 'book':
        return "Book";
      case 'picture_book':
        return "Picture Book";
      case 'radio':
        return "Radio";
      case 'music':
        return "Music";
      default:
        return 'Unknown';
    }
  }

  static String parseRating(String value) {
    switch (value) {
      case 'g':
        return "G - All Ages";
      case 'pg':
        return "PG - Children";
      case 'pg_13':
        return "PG 13 - Teens 13 and Older";
      case 'r':
        return "R - 17+ (Violence & Profanity)";
      case 'r+':
        return "R+ - Profanity & Mild Nudity";
      case 'rx':
        return "Rx - Hentai";
      default:
        return 'Unknown';
    }
  }

  static String parseRelationType(String value) {
    switch (value) {
      case 'sequel':
        return "Sequel";
      case 'prequel':
        return "Prequel";
      case 'alternative_setting':
        return "Alt. Setting";
      case 'alternative_version':
        return "Alt. Version";
      case 'side_story':
        return "Side Story";
      case 'parent_story':
        return "Parent Story";
      case 'summary':
        return "Summary";
      case 'Full Story':
        return "Sequel";
      default:
        return 'Unknown';
    }
  }

  factory AnimeDetails.fromMap(Map<String, dynamic> map) {
    return AnimeDetails(
      id: map['id'] as int,
      title: map['title'] as String,
      mediumImage: map['main_picture'] != null && map['main_picture']['medium'] != null
          ? map['main_picture']['medium'] as String
          : null,
      largeImage: map['main_picture'] != null && map['main_picture']['large'] != null
          ? map['main_picture']['large'] as String
          : null,
      synonyms: map['alternative_titles'] != null && map['alternative_titles']['synonyms'] != null
          ? List<String>.from((map['alternative_titles']['synonyms']))
          : null,
      enTitle: map['alternative_titles'] != null && map['alternative_titles']['en'] != null
          ? map['alternative_titles']['en'] as String
          : null,
      jaTitle: map['alternative_titles'] != null && map['alternative_titles']['ja'] != null
          ? map['alternative_titles']['ja'] as String
          : null,
      startDate: map['start_date'] != null ? map['start_date'] as String : null,
      endDate: map['end_date'] != null ? map['end_date'] as String : null,
      synopsis: map['synopsis'] != null ? map['synopsis'] as String : null,
      mean: map['mean'] != null ? map['mean'] as double : null,
      rank: map['rank'] != null ? map['rank'] as int : null,
      popularity: map['popularity'] != null ? map['popularity'] as int : null,
      numberListUsers: map['num_list_users'] as int,
      numberScoringUsers: map['num_list_users'] as int,
      nsfw: map['nsfw'] != null ? map['nsfw'] as String : null,
      genres: List<(int, String)>.from((map['genres'] as List).map((record) => (record['id'], record['name']))),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      mediaType: map['media_type'] as String,
      status: map['status'] as String,
      myListStatus:
          map['my_list_status'] != null ? MyListStatus.fromMap(map['my_list_status'] as Map<String, dynamic>) : null,
      numberEpisodes: map['num_episodes'] as int,
      startSeason: map['start_season'] != null
          ? (map['start_season']['year'] as int, map['start_season']['season'] as String)
          : null,
      broadcast: map['broadcast'] != null
          ? (map['broadcast']['day_of_the_week'] as String, map['broadcast']['start_time'] as String)
          : null,
      source: map['source'] != null ? map['source'] as String : null,
      averageEpDurationInSec: map['average_episode_duration'] != null ? map['average_episode_duration'] as int : null,
      rating: map['rating'] != null ? map['rating'] as String : null,
      studios: List<(int, String)>.from((map['studios'] as List).map((record) => (record['id'], record['name']))),
      pictures: map['pictures'] != null
          ? List<(String?, String?)>.from(
              (map['pictures'] as List).map((record) => (record['medium'], record['large'])))
          : null,
      background: map['background'] != null ? map['background'] as String : null,
      relatedAnime: List<RelatedItem>.from(
        (map['related_anime']).map(
          (x) => RelatedItem.fromMap(x),
        ),
      ),
      relatedManga: List<RelatedItem>.from(
        (map['related_manga']).map<RelatedItem>(
          (x) => RelatedItem.fromMap(x),
        ),
      ),
      statistics: map['statistics'] != null ? StatisticsItem.fromMap(map['statistics']) : null,
      recommendations: List<RecommendationItem>.from(
        (map['recommendations']).map(
          (x) => RecommendationItem.fromMap(x),
        ),
      ),
      openingThemes:
          map['opening_themes'] != null ? List.from((map['opening_themes'] as List).map((e) => e['text'])) : null,
      endingThemes:
          map['ending_themes'] != null ? List.from((map['ending_themes'] as List).map((e) => e['text'])) : null,
    );
  }
}
