import 'anime_details_model.dart';

class MyMangaListStatus {
  final String myStatus; // Parse
  final int myScore;
  final int volumesRead;
  final int chaptersRead;
  final bool isRereading;
  final DateTime updatedAt;

  MyMangaListStatus({
    required this.myStatus,
    required this.myScore,
    required this.volumesRead,
    required this.chaptersRead,
    required this.isRereading,
    required this.updatedAt,
  });

  factory MyMangaListStatus.fromMap(Map<String, dynamic> map) {
    return MyMangaListStatus(
      myStatus: map['status'] as String,
      myScore: map['score'] as int,
      volumesRead: map['num_volumes_read'] as int,
      chaptersRead: map['num_chapters_read'] as int,
      isRereading: map['is_rereading'] as bool,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class MangaStatisticsItem {
  final int numberListUsers;
  final int reading;
  final int complete;
  final int onHold;
  final int dropped;
  final int planToRead;

  MangaStatisticsItem({
    required this.numberListUsers,
    required this.reading,
    required this.complete,
    required this.onHold,
    required this.dropped,
    required this.planToRead,
  });

  factory MangaStatisticsItem.fromMap(Map<String, dynamic> map) {
    return MangaStatisticsItem(
      numberListUsers: map['num_list_users'] as int,
      reading: int.parse(map['status']['reading'].toString()),
      complete: int.parse(map['status']['completed'].toString()),
      onHold: int.parse(map['status']['on_hold'].toString()),
      dropped: int.parse(map['status']['dropped'].toString()),
      planToRead: int.parse(map['status']['plan_to_read'].toString()),
    );
  }
}

class Author {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? role;

  Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['node']['id'] as int,
      firstName: map['node']['first_name'] ?? "",
      lastName: map['node']['last_name'] ?? "",
      role: map['role'] ?? "Unknown",
    );
  }
}

class MangaDetails {
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
  final MyMangaListStatus? myMangaListStatus;
  final int numberVolumes;
  final int numberChapters;
  final List<Author> authors;
  final List<(String?, String?)>? pictures;
  final String? background;
  final List<RelatedItem> relatedAnime;
  final List<RelatedItem> relatedManga;
  final MangaStatisticsItem? statistics;
  final List<RecommendationItem> recommendations;
  final List<(int, String)>? serialization;

  MangaDetails({
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
    required this.myMangaListStatus,
    required this.numberVolumes,
    required this.numberChapters,
    required this.authors,
    required this.pictures,
    required this.background,
    required this.relatedAnime,
    required this.relatedManga,
    required this.statistics,
    required this.recommendations,
    required this.serialization,
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
      case 'manga':
        return 'Manga';
      case 'novel':
        return 'Novel';
      case 'one_shot':
        return 'One Shot';
      case 'doujinshi':
        return 'Doujinshi';
      case 'manhwa':
        return 'Manhwa';
      case 'Manhua':
        return 'Manhua';
      case 'oel':
        return 'Oel';
      default:
        return 'Unknown';
    }
  }

  static String parseStatus(String status, {bool short = false}) {
    switch (status) {
      case 'reading':
        return "Reading";
      case 'completed':
        return "Completed";
      case 'on_hold':
        return "On Hold";
      case 'dropped':
        return "Dropped";
      case 'plan_to_read':
        return short ? "PTR" : "Plan to Read";
      case 'finished':
        return "FP";
      case 'currently_publishing':
        return short ? "CP" : "Currently Publishing";
      case 'not_yet_published':
        return short ? "NYP" : "Not Yet Published";
      default:
        return short ? 'N/A' : "Unknown";
    }
  }

  static String parseRelationType(String value) {
    switch (value) {
      case 'sequel':
        return "Sequel";
      case 'prequel':
        return "Prequel";
      case 'alternative_setting':
        return "Alternative Setting";
      case 'alternative_version':
        return "Alternative Version";
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

  factory MangaDetails.fromMap(Map<String, dynamic> map) {
    return MangaDetails(
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
      myMangaListStatus: map['my_list_status'] != null
          ? MyMangaListStatus.fromMap(map['my_list_status'] as Map<String, dynamic>)
          : null,
      numberVolumes: map['num_volumes'] as int,
      numberChapters: map['num_chapters'] as int,
      authors: List<Author>.from((map['authors'] as List).map((record) => Author.fromMap(record))),
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
      statistics: map['statistics'] != null ? MangaStatisticsItem.fromMap(map['statistics']) : null,
      recommendations: List<RecommendationItem>.from(
        (map['recommendations']).map(
          (x) => RecommendationItem.fromMap(x),
        ),
      ),
      serialization: List<(int, String)>.from(
          (map['serialization'] as List).map((record) => (record['node']['id'], record['node']['name']))),
    );
  }
}
