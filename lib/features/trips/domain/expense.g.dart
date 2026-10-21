// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  tripId: json['trip_id'] as String,
  userId: json['user_id'] as String?,
  category:
      $enumDecodeNullable(_$ExpenseCategoryEnumMap, json['category']) ??
      ExpenseCategory.other,
  amount: (json['amount'] as num?)?.toDouble() ?? 0,
  note: json['note'] as String?,
  day: (json['day'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'trip_id': instance.tripId,
  'user_id': instance.userId,
  'category': _$ExpenseCategoryEnumMap[instance.category]!,
  'amount': instance.amount,
  'note': instance.note,
  'day': instance.day,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.stay: 'stay',
  ExpenseCategory.food: 'food',
  ExpenseCategory.sight: 'sight',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.other: 'other',
};
