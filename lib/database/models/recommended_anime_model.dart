class UserAnimeListItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final String? status;
  final int score;
  final int episodesWatched;
  final bool isRewatching;
  final DateTime updatedAt;

  UserAnimeListItem({
    required this.id,
    required this.title,
    this.mediumImage,
    this.largeImage,
    this.status,
    required this.score,
    required this.episodesWatched,
    required this.isRewatching,
    required this.updatedAt,
  });

  static String parseStatus(String status) {
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
        return "Plan to Watch";
      default:
        return "Undefined State";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mediumImage': mediumImage,
      'largeImage': largeImage,
      'status': status,
      'score': score,
      'episodesWatched': episodesWatched,
      'isRewatching': isRewatching ? 1 : 0,
      'updatedAt': updatedAt.toString(),
    };
  }

  factory UserAnimeListItem.fromMap(Map<String, dynamic> map) {
    return UserAnimeListItem(
      id: map['id'],
      title: map['title'],
      mediumImage: map['mediumImage'],
      largeImage: map['largeImage'],
      status: map['status'],
      score: map['score'],
      episodesWatched: map['episodesWatched'],
      isRewatching: map['isRewatching'] == 1 ? true : false,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  factory UserAnimeListItem.fromJSON(Map<String, dynamic> map) {
    return UserAnimeListItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture']['medium'],
      largeImage: map['node']['main_picture']['large'],
      status: map['list_status']['status'],
      score: map['list_status']['score'],
      episodesWatched: map['list_status']['num_episodes_watched'],
      isRewatching: map['list_status']['is_rewatching'] == 1 ? true : false,
      updatedAt: DateTime.parse(map['list_status']['updated_at']),
    );
  }
}
