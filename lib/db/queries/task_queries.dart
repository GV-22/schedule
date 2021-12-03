import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '/context.dart';
import '../entities/task.dart';
import '/helpers/converter_helpers.dart';
import '/helpers/type_helpers.dart';
import '/helpers/utils.dart';

class TaskQueries {
  final Database _db;

  const TaskQueries(this._db);

  Future<Iterable<TaskEntity>> getTasks() async {
    // print('fetch TaskEntities query enter');
    final rows = await _db.rawQuery(
      '''
      select task_id, subject_id, day_code, start_time, end_time, description, archived
      from s_task
      order by ts
    ''',
    );

    // print('fetch TaskEntities query ${rows.length}');
    List<TaskEntity> _tasks = [];
    for (var row in rows) {
      _tasks.add(await _dbToTaskEntity(row));
    }

    return _tasks;
  }

  Future<TaskEntity> getTask(int taskId) async {
    final rows = await _db.rawQuery(
      '''
      select task_id, label, color_code, archived
      from s_task
      where task_id = ?
    ''',
      [taskId],
    );

    return await _dbToTaskEntity(rows.first);
  }

  Future<int> insertTask(TaskToAddEntity input) async {
    return await _db.transaction((txn) async {
      return await txn.insert(
        's_task',
        {
          'subject_id': input.subject.subjectId,
          'description': input.description,
          'start_time': timeOfDayToString(input.startTime),
          'end_time': timeOfDayToString(input.endTime),
          'day_code': input.dayCode,
        },
      );
    });
  }

  Future<void> updateTask(TaskEntity input) async {
    await _db.transaction((txn) async {
      await txn.update(
        's_task',
        {
          'subject_id': input.subject.subjectId,
          'description': input.description,
          'start_time': timeOfDayToString(input.startTime),
          'end_time': timeOfDayToString(input.endTime),
          'day_code': input.dayCode,
          'archived': input.archived ? 1 : 0
        },
        where: 'task_id = ?',
        whereArgs: [input.taskId],
      );
    });
  }

  Future<void> deleteTask(TaskEntity task) async {
    await _db.transaction((txn) async {
      await txn.delete(
        's_task',
        where: 'task_id = ?',
        whereArgs: [task.taskId],
      );
    });
    printLog(message: "[DATABSE] Deleted task: ${task.toString()}");
  }

  Future<TaskEntity> _dbToTaskEntity(Map<String, Object?> row) async {
    return TaskEntity(
      taskId: intVal(row['task_id']),
      dayCode: strVal(row['day_code']),
      startTime: stringToTimeOfDay(strVal(row['start_time'])),
      endTime: stringToTimeOfDay(strVal(row['end_time'])),
      description: strValOrNull(row['description']),
      archived: row['archived'] == 1,
      subject: await subjectQueries.getSubject(intVal(row['subject_id'])),
    );
  }
}
