import 'package:flutter/cupertino.dart';

/// Used to add an subject
class SubjectToAddEntity {
  final String label;
  final Color color;

  const SubjectToAddEntity({
    required this.label,
    required this.color,
  });

  @override
  String toString() {
    return 'SubjectToAddEntity(label: $label, color: $color)';
  }
}

/// Used to manage the UI
class SubjectEntity {
  final int subjectId;
  String label;
  Color color;
  final bool archived;
  // final DateTime ts;

  SubjectEntity({
    required this.subjectId,
    required this.label,
    required this.color,
    required this.archived,
    // required this.ts
  });

  @override
  String toString() {
    return 'SubjectEntity(subjectId: $subjectId, label: $label, color: $color, archived: $archived)';
  }
}
