class PracticeRecord {
  final int? id;
  final DateTime date;
  final String instrument;
  final int duration;
  final String notes;

  PracticeRecord({
    this.id,
    required this.date,
    required this.instrument,
    required this.duration,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'instrument': instrument,
      'duration': duration,
      'notes': notes,
    };
  }

  factory PracticeRecord.fromMap(Map<String, dynamic> map) {
    return PracticeRecord(
      id: map['id'],
      date: DateTime.parse(map['date']),
      instrument: map['instrument'],
      duration: map['duration'],
      notes: map['notes'],
    );
  }
}
