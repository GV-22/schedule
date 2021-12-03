import 'package:flutter/material.dart';
import 'subject.dart';

/// Used to add a task
class TaskToAddEntity {
  final String? description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String dayCode;
  final SubjectEntity subject;

  const TaskToAddEntity({
    required this.startTime,
    required this.endTime,
    required this.dayCode,
    required this.subject,
    this.description,
  });

  @override
  String toString() {
    return 'TaskToAddEntity(startTime: $startTime, endTime: $endTime, '
        'description: $description, dayCode: $dayCode, subject: ${subject.toString()})';
  }
}

/// Used to manage the UI
class TaskEntity {
  final int taskId;
  final String? description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String dayCode;
  final SubjectEntity subject;
  final bool archived;

  const TaskEntity({
    required this.taskId,
    required this.startTime,
    required this.endTime,
    this.description,
    required this.dayCode,
    required this.subject,
    required this.archived,
  });

  @override
  String toString() {
    return 'TaskEntity(taskId: $taskId, startTime: $startTime, endTime: $endTime,'
        'description: $description, day : $dayCode), archived: $archived, subject: ${subject.toString()}';
  }
}
