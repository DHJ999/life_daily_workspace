/// 体重体脂记录
class FitnessRecord {
  final String id;
  final String date; // yyyy-MM-dd
  final double weight; // kg
  final double bodyFat; // %
  final String note;

  const FitnessRecord({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFat,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'weight': weight,
        'bodyFat': bodyFat,
        'note': note,
      };

  factory FitnessRecord.fromJson(Map<String, dynamic> json) => FitnessRecord(
        id: json['id'] as String,
        date: json['date'] as String,
        weight: (json['weight'] as num).toDouble(),
        bodyFat: (json['bodyFat'] as num).toDouble(),
        note: json['note'] as String? ?? '',
      );
}
