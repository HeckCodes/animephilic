/*
{
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
*/

class Stat {
  static int length = 15;

  final int id = 1;
  final int numItemsWatching;
  final int numItemsCompleted;
  final int numItemsOnHold;
  final int numItemsDropped;
  final int numItemsPlanToWatch;
  final int numItems;
  final int numEpisodes;
  final int numTimesRewatched;

  final double numDaysWatched;
  final double numDaysWatching;
  final double numDaysCompleted;
  final double numDaysOnHold;
  final double numDaysDropped;
  final double numDays;
  final double meanScore;

  Stat({
    required this.numItemsWatching,
    required this.numItemsCompleted,
    required this.numItemsOnHold,
    required this.numItemsDropped,
    required this.numItemsPlanToWatch,
    required this.numItems,
    required this.numEpisodes,
    required this.numTimesRewatched,
    required this.numDaysWatched,
    required this.numDaysWatching,
    required this.numDaysCompleted,
    required this.numDaysOnHold,
    required this.numDaysDropped,
    required this.numDays,
    required this.meanScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numItemsWatching': numItemsWatching,
      'numItemsCompleted': numItemsCompleted,
      'numItemsOnHold': numItemsOnHold,
      'numItemsDropped': numItemsDropped,
      'numItemsPlanToWatch': numItemsPlanToWatch,
      'numItems': numItems,
      'numEpisodes': numEpisodes,
      'numTimesRewatched': numTimesRewatched,
      'numDaysWatched': numDaysWatched.toString(),
      'numDaysWatching': numDaysWatching.toString(),
      'numDaysCompleted': numDaysCompleted.toString(),
      'numDaysOnHold': numDaysOnHold.toString(),
      'numDaysDropped': numDaysDropped.toString(),
      'numDays': numDays.toString(),
      'meanScore': meanScore.toString(),
    };
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      numItemsWatching: map['numItemsWatching'],
      numItemsCompleted: map['numItemsCompleted'],
      numItemsOnHold: map['numItemsOnHold'],
      numItemsDropped: map['numItemsDropped'],
      numItemsPlanToWatch: map['numItemsPlanToWatch'],
      numItems: map['numItems'],
      numEpisodes: map['numEpisodes'],
      numTimesRewatched: map['numTimesRewatched'],
      numDaysWatched: double.parse(map['numDaysWatched']),
      numDaysWatching: double.parse(map['numDaysWatching']),
      numDaysCompleted: double.parse(map['numDaysCompleted']),
      numDaysOnHold: double.parse(map['numDaysOnHold']),
      numDaysDropped: double.parse(map['numDaysDropped']),
      numDays: double.parse(map['numDays']),
      meanScore: double.parse(map['meanScore']),
    );
  }

  factory Stat.fromJSON(Map<String, dynamic> map) {
    return Stat(
      numItemsWatching: map['num_items_watching'],
      numItemsCompleted: map['num_items_completed'],
      numItemsOnHold: map['num_items_on_hold'],
      numItemsDropped: map['num_items_dropped'],
      numItemsPlanToWatch: map['num_items_plan_to_watch'],
      numItems: map['num_items'],
      numEpisodes: map['num_episodes'],
      numTimesRewatched: map['num_times_rewatched'],
      numDaysWatched: map['num_days_watched'],
      numDaysWatching: map['num_days_watching'],
      numDaysCompleted: map['num_days_completed'],
      numDaysOnHold: map['num_days_on_hold'],
      numDaysDropped: map['num_days_dropped'],
      numDays: map['num_days'],
      meanScore: map['mean_score'],
    );
  }

  @override
  String toString() {
    return 'Stat(numItemsWatching: $numItemsWatching, numItemsCompleted: $numItemsCompleted, '
        'numItemsOnHold: $numItemsOnHold, numItemsDropped: $numItemsDropped, '
        'numItemsPlanToWatch: $numItemsPlanToWatch, numItems: $numItems, '
        'numDaysWatched: $numDaysWatched, numDaysWatching: $numDaysWatching, '
        'numDaysCompleted: $numDaysCompleted, numDaysOnHold: $numDaysOnHold, '
        'numDaysDropped: $numDaysDropped, numDays: $numDays, '
        'numEpisodes: $numEpisodes, numTimesRewatched: $numTimesRewatched, meanScore: $meanScore)';
  }
}
