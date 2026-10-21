import '../../../../shared/widgets/ventus_icon.dart';
import '../../domain/activity_kind.dart';

/// The timeline icon for an activity kind (prototype `TripHub.jsx` icons).
String activityKindIcon(ActivityKind kind) => switch (kind) {
  ActivityKind.flight => VentusIcons.plane,
  ActivityKind.stay => VentusIcons.bed,
  ActivityKind.food => VentusIcons.cup,
  ActivityKind.sight => VentusIcons.star,
  ActivityKind.transport => VentusIcons.car,
  ActivityKind.activity => VentusIcons.mapPin,
};

/// Formats minutes-from-midnight as 24h "HH:mm". Returns null for no set time.
String? formatStartMinutes(int? minutes) {
  if (minutes == null) return null;
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
