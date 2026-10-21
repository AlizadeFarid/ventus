/// The kind of an itinerary activity — drives its icon in the timeline and lets
/// Ventus reason about a day's shape later (travel vs. food vs. sightseeing).
///
/// Persisted as its lowercase name (e.g. `food`) in the
/// `itinerary_items.kind` column and JSON. [activity] is the neutral default.
enum ActivityKind { flight, stay, food, sight, transport, activity }
