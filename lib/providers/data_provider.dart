import 'package:flutter/material.dart';
import '../context.dart';
import '../db/entities/subject.dart';
import '../db/entities/task.dart';
import '../helpers/utils.dart';

class DataProvider with ChangeNotifier {
  final List<SubjectEntity> _subjects = [];
  final List<TaskEntity> _tasks = [];

  // getters
  List<SubjectEntity> get subjects => [..._subjects];
  List<TaskEntity> get tasks => [..._tasks];

  List<TaskEntity> getTasksByDay(String dayCode) =>
      _tasks.where((ts) => ts.dayCode == dayCode).toList();

  SubjectEntity getSubjectEntity(int subjectId) {
    try {
      return _subjects.firstWhere((i) => i.subjectId == subjectId);
    } catch (e) {
      rethrow;
    }
  }

  SubjectEntity? getSubjectEntityByName(String label) {
    try {
      return _subjects.firstWhere(
        (i) => i.label.toLowerCase() == label.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  TaskEntity getTaskEntity(int taskId) {
    try {
      return _tasks.firstWhere((i) => i.taskId == taskId);
    } catch (e) {
      rethrow;
    }
  }

  /// insert values in items
  void setItems<T>(List<T> items, List<T> values) {
    items.clear();
    items.addAll(values);

    notifyListeners();
  }

  void setItem<T>(T item, List<T> arrays) {
    int index = -1;
    if (item is SubjectEntity) {
      final tmp = arrays as List<SubjectEntity>;
      index = tmp.indexWhere((i) => i.subjectId == item.subjectId);
    } else if (item is TaskEntity) {
      final tmp = arrays as List<TaskEntity>;
      index = tmp.indexWhere((i) => i.taskId == item.taskId);
    }

    if (index == -1) {
      throw "Unknown $T: '${item.toString()}'";
    }

    arrays[index] = item;

    notifyListeners();
  }

  void addItem<T>(T item, List<T> arrays) {
    // print("[add item: $T] :: ${item.toString()}");
    arrays.add(item);

    notifyListeners();
  }

  void removeItem<T>(T item, List<T> arrays) {
    arrays.removeAt(getIndex(item, arrays));

    notifyListeners();
  }

  // task
  Future<void> retrieveTasks() async {
    if (_tasks.isNotEmpty) return;
    setItems<TaskEntity>(_tasks, (await taskQueries.getTasks()).toList());
  }

  Future<void> insertTask(TaskToAddEntity task) async {
    printLog(message: "[INSERT] taskToAddEntity ${task.toString()}");

    final int insertedTaskId = await taskQueries.insertTask(task);
    final TaskEntity newTask = TaskEntity(
      taskId: insertedTaskId,
      startTime: task.startTime,
      endTime: task.endTime,
      dayCode: task.dayCode,
      description: task.description,
      archived: false,
      subject: task.subject,
    );
    addItem<TaskEntity>(newTask, _tasks);
  }

  Future<void> updateTask(TaskEntity task) async {
    printLog(message: "[UPDATE] TaskEntity ${task.toString()}");

    await taskQueries.updateTask(task);
    setItem<TaskEntity>(task, _tasks);
  }

  Future<void> deleteTask(TaskEntity task) async {
    await taskQueries.deleteTask(task);
    removeItem<TaskEntity>(task, _tasks);
  }

  // subjects
  Future<void> retrieveSubjects() async {
    if (_subjects.isNotEmpty) return;
    setItems<SubjectEntity>(
      _subjects,
      (await subjectQueries.getSubjects()).toList(),
    );
  }

  Future<void> insertSubject(SubjectToAddEntity subject) async {
    printLog(message: "[INSERT] SubjectToAddEntity ${subject.toString()}");

    final int insertedSubjectId = await subjectQueries.insertSubject(subject);
    final SubjectEntity newSubject = SubjectEntity(
        subjectId: insertedSubjectId,
        label: subject.label,
        color: subject.color,
        archived: false);
    addItem<SubjectEntity>(newSubject, _subjects);
  }

  Future<void> updateSubject(SubjectEntity subject) async {
    printLog(message: "[UPDATE] SubjectEntity ${subject.toString()}");

    await subjectQueries.updateSubject(subject);
    setItem<SubjectEntity>(subject, _subjects);
  }

  Future<void> deleteSubject(SubjectEntity subject) async {
    List<TaskEntity> relatedTasks = _tasks
        .where((task) => task.subject.subjectId == subject.subjectId)
        .toList();
    await subjectQueries.deleteSubject(subject, relatedTasks);
    removeItem<SubjectEntity>(subject, _subjects);
  }
}
