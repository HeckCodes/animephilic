class RecommendedAnimeItem {
  final int id;
  final String title;
  final String? mediumImage;
  final String? largeImage;
  final double? mean;

  RecommendedAnimeItem({
    required this.id,
    required this.title,
    this.mediumImage,
    this.largeImage,
    this.mean,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mediumImage': mediumImage,
      'largeImage': largeImage,
      'mean': mean?.toString(),
    };
  }

  factory RecommendedAnimeItem.fromMap(Map<String, dynamic> map) {
    return RecommendedAnimeItem(
      id: map['id'],
      title: map['title'],
      mediumImage: map['mediumImage'],
      largeImage: map['largeImage'],
      mean: map['mean'] == null ? null : double.parse(map['mean']),
    );
  }

  factory RecommendedAnimeItem.fromJSON(Map<String, dynamic> map) {
    return RecommendedAnimeItem(
      id: map['node']['id'],
      title: map['node']['title'],
      mediumImage: map['node']['main_picture'] != null ? map['node']['main_picture']['medium'] : null,
      largeImage: map['node']['main_picture'] != null ? map['node']['main_picture']['large'] : null,
      mean: map['node']['mean'] == null ? null : double.parse(map['node']['mean'].toString()),
    );
  }
}
