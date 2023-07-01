/*
  Valid values: (for status)
    reading
    completed
    on_hold
    dropped
    plan_to_read
 */

class UserMangaListItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final String? status;
  final int score;
  final int volumesRead;
  final int chaptersRead;
  final bool isRereading;
  final DateTime updatedAt;

  UserMangaListItem({
    required this.id,
    required this.title,
    this.mediumImage,
    this.largeImage,
    this.status,
    required this.score,
    required this.volumesRead,
    required this.chaptersRead,
    required this.isRereading,
    required this.updatedAt,
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
      default:
        return short ? 'N/A' : "Undefined State";
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
      'volumesRead': volumesRead,
      'chaptersRead': chaptersRead,
      'isRereading': isRereading ? 1 : 0,
      'updatedAt': updatedAt.toString(),
    };
  }

  factory UserMangaListItem.fromMap(Map<String, dynamic> map) {
    return UserMangaListItem(
      id: map['id'],
      title: map['title'],
      mediumImage: map['mediumImage'],
      largeImage: map['largeImage'],
      status: map['status'],
      score: map['score'],
      volumesRead: map['volumesRead'],
      chaptersRead: map['chaptersRead'],
      isRereading: map['isRereading'] == 1 ? true : false,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  factory UserMangaListItem.fromJSON(Map<String, dynamic> map) {
    return UserMangaListItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture']['medium'],
      largeImage: map['node']['main_picture']['large'],
      status: map['list_status']['status'],
      score: map['list_status']['score'],
      volumesRead: map['list_status']['num_volumes_read'],
      chaptersRead: map['list_status']['num_chapters_read'],
      isRereading: map['list_status']['is_rereading'] == 1 ? true : false,
      updatedAt: DateTime.parse(map['list_status']['updated_at']),
    );
  }
}
