class MangaRankingItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final double? mean;
  final int? popularity;
  final int numberListUsers;
  final int numberScoringUsers;
  final String status;
  final int rank;

  MangaRankingItem({
    required this.id,
    required this.title,
    this.mediumImage,
    this.largeImage,
    this.mean,
    this.popularity,
    required this.numberListUsers,
    required this.numberScoringUsers,
    required this.status,
    required this.rank,
  });

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

  // Boolean to 1/0 and DateTime to String
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mediumImage': mediumImage,
      'largeImage': largeImage,
      'mean': mean?.toString(),
      'popularity': popularity,
      'numberListUsers': numberListUsers,
      'numberScoringUsers': numberScoringUsers,
      'status': status,
      'rank': rank,
    };
  }

  factory MangaRankingItem.fromMap(Map<String, dynamic> map) {
    return MangaRankingItem(
      id: map['id'],
      title: map['title'],
      mediumImage: map['mediumImage'],
      largeImage: map['largeImage'],
      mean: map['mean'] == null ? null : double.parse(map['mean']),
      popularity: map['popularity'],
      numberListUsers: map['numberListUsers'],
      numberScoringUsers: map['numberScoringUsers'],
      status: map['status'],
      rank: map['rank'],
    );
  }

  factory MangaRankingItem.fromJSON(Map<String, dynamic> map) {
    return MangaRankingItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture'] != null ? map['node']['main_picture']['medium'] : null,
      largeImage: map['node']['main_picture'] != null ? map['node']['main_picture']['large'] : null,
      mean: map['node']['mean'] == null ? null : double.parse(map['node']['mean'].toString()),
      popularity: map['node']['popularity'],
      numberListUsers: map['node']['num_list_users'],
      numberScoringUsers: map['node']['num_scoring_users'],
      status: map['node']['status'],
      rank: map['ranking']['rank'],
    );
  }
}
