/*
{
  node: {
    id: 55016, 
    title: Idol, 
    main_picture: {
      medium: https://cdn.myanimelist.net/images/anime/1921/135489.jpg, 
      large: https://cdn.myanimelist.net/images/anime/1921/135489l.jpg
    }, 
    mean: 8.85, 
    popularity: 4509, 
    num_list_users: 20767, 
    num_scoring_users: 14481, 
    media_type: music, 
    status: finished_airing
  }
}
*/

class SeasonalAnimeItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final int year;
  final String season;
  final double? mean;
  final int? popularity;
  final int numberListUsers;
  final int numberScoringUsers;
  final String mediaType;
  final String status;

  SeasonalAnimeItem({
    required this.id,
    required this.title,
    this.mediumImage,
    this.largeImage,
    required this.year,
    required this.season,
    this.mean,
    this.popularity,
    required this.numberListUsers,
    required this.numberScoringUsers,
    required this.mediaType,
    required this.status,
  });

  static String parseSeason(int month) {
    if (month >= 1 && month <= 3) return "winter";
    if (month >= 4 && month <= 6) return "spring";
    if (month >= 7 && month <= 9) {
      return "summer";
    } else {
      return "fall";
    }
  }

  static String parseStatus(String status, {bool short = false}) {
    switch (status) {
      case 'finished_airing':
        return short ? "Finished" : "Finished Airing";
      case 'currently_airing':
        return short ? "Airing" : "Currently Airing";
      case 'not_yet_aired':
        return short ? "Not Aired" : "Not Yet Aired";
      default:
        return "undefined";
    }
  }

  // Boolean to 1/0 and DateTime to String
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mediumImage': mediumImage,
      'largeImage': largeImage,
      'year': year,
      'season': season,
      'mean': mean?.toString(),
      'popularity': popularity,
      'numberListUsers': numberListUsers,
      'numberScoringUsers': numberScoringUsers,
      'mediaType': mediaType,
      'status': status,
    };
  }

  factory SeasonalAnimeItem.fromMap(Map<String, dynamic> map) {
    return SeasonalAnimeItem(
      id: map['id'],
      title: map['title'],
      mediumImage: map['mediumImage'],
      largeImage: map['largeImage'],
      year: map['year'],
      season: map['season'],
      mean: map['mean'] == null ? null : double.parse(map['mean']),
      popularity: map['popularity'],
      numberListUsers: map['numberListUsers'],
      numberScoringUsers: map['numberScoringUsers'],
      mediaType: map['mediaType'],
      status: map['status'],
    );
  }

  factory SeasonalAnimeItem.fromJSON(Map<String, dynamic> map, int year, String season) {
    return SeasonalAnimeItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture']['medium'],
      largeImage: map['node']['main_picture']['large'],
      year: year,
      season: season,
      mean: map['node']['mean'] == null ? null : double.parse(map['node']['mean'].toString()),
      popularity: map['node']['popularity'],
      numberListUsers: map['node']['num_list_users'],
      numberScoringUsers: map['node']['num_scoring_users'],
      mediaType: map['node']['media_type'],
      status: map['node']['status'],
    );
  }
}
