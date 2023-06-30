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
    status: finished_airing
  }
}
*/

class AnimeRankingItem {
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

  AnimeRankingItem({
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

  static String parseStatus(String status) {
    switch (status) {
      case 'finished_airing':
        return "Finished Airing";
      case 'currently_airing':
        return "Currently Airing";
      case 'not_yet_aired':
        return "Not Yet Aired";
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
      'mean': mean?.toString(),
      'popularity': popularity,
      'numberListUsers': numberListUsers,
      'numberScoringUsers': numberScoringUsers,
      'status': status,
      'rank': rank,
    };
  }

  factory AnimeRankingItem.fromMap(Map<String, dynamic> map) {
    return AnimeRankingItem(
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

  factory AnimeRankingItem.fromJSON(Map<String, dynamic> map) {
    return AnimeRankingItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture']['medium'],
      largeImage: map['node']['main_picture']['large'],
      mean: map['node']['mean'] == null
          ? null
          : double.parse(map['node']['mean'].toString()),
      popularity: map['node']['popularity'],
      numberListUsers: map['node']['num_list_users'],
      numberScoringUsers: map['node']['num_scoring_users'],
      status: map['node']['status'],
      rank: map['ranking']['rank'],
    );
  }
}
