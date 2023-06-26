/*
{
  id: 14178956, 
  name: HeckRoger, 
  gender: male, 
  birthday: 2000-02-07, 
  location: Earth, 
  joined_at: 2021-12-13T10:08:12+00:00, 
  picture: https://cdn.myanimelist.net/s/common/userimages/a21e15f7, 
  anime_statistics: {
    num_items_watching: 0, 
    num_items_completed: 87, 
    num_items_on_hold: 3, 
    num_items_dropped: 0, 
    num_items_plan_to_watch: 67, 
    num_items: 157, 
    num_days_watched: 14.51, 
    num_days_watching: 0, 
    num_days_completed: 14.18, 
    num_days_on_hold: 0.33, 
    num_days_dropped: 0, 
    num_days: 14.51, 
    num_episodes: 855, 
    num_times_rewatched: 0, 
    mean_score: 8.6
  }
}
*/

class User {
  final int id;
  final String name;
  final String picture;
  final String? gender;
  final DateTime? birthday;
  final String? location;
  final DateTime joined;
  final String? timezone;
  final bool? isSupporter;

  const User({
    required this.id,
    required this.name,
    required this.picture,
    this.gender,
    this.birthday,
    this.location,
    required this.joined,
    this.timezone,
    this.isSupporter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'picture': picture,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'location': location,
      'joined': joined.toIso8601String(),
      'timezone': timezone,
      'isSupporter': isSupporter == null || isSupporter == false ? 0 : 1,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      picture: map['picture'],
      gender: map['gender'],
      birthday:
          map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      location: map['location'],
      joined: DateTime.parse(map['joined']),
      timezone: map['timezone'],
      isSupporter:
          map['isSupporter'] == 0 || map['isSupporter'] == null ? false : true,
    );
  }

  factory User.fromJSON(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      picture: map['picture'],
      gender: map['gender'],
      birthday:
          map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      location: map['location'],
      joined: DateTime.parse(map['joined_at']),
      timezone: map['time_zone'],
      isSupporter: map['is_supporter'] == 0 || map['is_supporter'] == null
          ? false
          : true,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, picture: $picture, gender: $gender, birthday: $birthday, '
        'location: $location, joined: $joined, timezone: $timezone, isSupporter: $isSupporter)';
  }
}
