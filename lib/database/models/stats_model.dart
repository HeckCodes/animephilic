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

class Stats {
  final int numItemsWatching;
  final int numItemsCompleted;
  final int numItemsOnHold;
  final int numItemsDropped;
  final int numItemsPlanToWatch;
  final int numItems;
  final double numDaysWatched;
  final double numDaysWatching;
  final double numDaysCompleted;
  final double numDaysOnHold;
  final double numDaysDropped;
  final double numDays;
  final int numEpisodes;
  final int numTimesRewatched;
  final double meanScore;

  Stats({
    required this.numItemsWatching,
    required this.numItemsCompleted,
    required this.numItemsOnHold,
    required this.numItemsDropped,
    required this.numItemsPlanToWatch,
    required this.numItems,
    required this.numDaysWatched,
    required this.numDaysWatching,
    required this.numDaysCompleted,
    required this.numDaysOnHold,
    required this.numDaysDropped,
    required this.numDays,
    required this.numEpisodes,
    required this.numTimesRewatched,
    required this.meanScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'numItemsWatching': numItemsWatching,
      'numItemsCompleted': numItemsCompleted,
      'numItemsOnHold': numItemsOnHold,
      'numItemsDropped': numItemsDropped,
      'numItemsPlanToWatch': numItemsPlanToWatch,
      'numItems': numItems,
      'numDaysWatched': numDaysWatched,
      'numDaysWatching': numDaysWatching,
      'numDaysCompleted': numDaysCompleted,
      'numDaysOnHold': numDaysOnHold,
      'numDaysDropped': numDaysDropped,
      'numDays': numDays,
      'numEpisodes': numEpisodes,
      'numTimesRewatched': numTimesRewatched,
      'meanScore': meanScore,
    };
  }

  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      numItemsWatching: map['numItemsWatching'],
      numItemsCompleted: map['numItemsCompleted'],
      numItemsOnHold: map['numItemsOnHold'],
      numItemsDropped: map['numItemsDropped'],
      numItemsPlanToWatch: map['numItemsPlanToWatch'],
      numItems: map['numItems'],
      numDaysWatched: map['numDaysWatched'],
      numDaysWatching: map['numDaysWatching'],
      numDaysCompleted: map['numDaysCompleted'],
      numDaysOnHold: map['numDaysOnHold'],
      numDaysDropped: map['numDaysDropped'],
      numDays: map['numDays'],
      numEpisodes: map['numEpisodes'],
      numTimesRewatched: map['numTimesRewatched'],
      meanScore: map['meanScore'],
    );
  }

  @override
  String toString() {
    return 'Stats(numItemsWatching: $numItemsWatching, numItemsCompleted: $numItemsCompleted, '
        'numItemsOnHold: $numItemsOnHold, numItemsDropped: $numItemsDropped, '
        'numItemsPlanToWatch: $numItemsPlanToWatch, numItems: $numItems, '
        'numDaysWatched: $numDaysWatched, numDaysWatching: $numDaysWatching, '
        'numDaysCompleted: $numDaysCompleted, numDaysOnHold: $numDaysOnHold, '
        'numDaysDropped: $numDaysDropped, numDays: $numDays, '
        'numEpisodes: $numEpisodes, numTimesRewatched: $numTimesRewatched, meanScore: $meanScore)';
  }
}
