// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripBudget _$TripBudgetFromJson(Map<String, dynamic> json) => _TripBudget(
  tripId: json['trip_id'] as String,
  userId: json['user_id'] as String?,
  currency: json['currency'] as String? ?? 'USD',
  total: (json['total'] as num?)?.toDouble() ?? 0,
  allocations:
      (json['allocations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const <String, double>{},
);

Map<String, dynamic> _$TripBudgetToJson(_TripBudget instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'user_id': instance.userId,
      'currency': instance.currency,
      'total': instance.total,
      'allocations': instance.allocations,
    };
