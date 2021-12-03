import '../../context.dart';
import '../entities/subject.dart';
import '../entities/task.dart';
import '../../helpers/converter_helpers.dart';
import '../../helpers/type_helpers.dart';
import '../../helpers/utils.dart';
import 'package:sqflite/sqflite.dart';

class SubjectQueries {
  final Database _db;

  const SubjectQueries(this._db);

  Future<Iterable<SubjectEntity>> getSubjects() async {
    final rows = await _db.rawQuery(
      '''
      select subject_id, label, color_code, archived
      from s_subject
      order by ts
    ''',
    );

    // print('fetch SubjectEntities query ${rows.length}');

    return rows.map(_dbToSubjectEntity);
  }

  Future<SubjectEntity> getSubject(int subjectId) async {
    final rows = await _db.rawQuery(
      '''
      select subject_id, label, color_code, archived
      from s_subject
      where subject_id = ?
    ''',
      [subjectId],
    );

    return _dbToSubjectEntity(rows.first);
  }

  Future<int> insertSubject(SubjectToAddEntity input) async {
    return await _db.transaction((txn) async {
      return await txn.insert('s_subject', {
        'label': input.label,
        'color_code': colorToStringRGB(input.color),
      });
    });
  }

  Future<void> updateSubject(SubjectEntity input) async {
    await _db.transaction((txn) async {
      await txn.update(
        's_subject',
        {
          'label': input.label,
          'color_code': colorToStringRGB(input.color),
          'archived': input.archived ? 1 : 0
        },
        where: 'subject_id = ?',
        whereArgs: [input.subjectId],
      );
    });
  }

  Future<void> deleteSubject(
      SubjectEntity subject, List<TaskEntity> relatedTasks) async {
    for (var task in relatedTasks) {
      await taskQueries.deleteTask(task);
    }
    await _db.transaction((txn) async {
      await txn.delete(
        's_subject',
        where: 'subject_id = ?',
        whereArgs: [subject.subjectId],
      );
    });
    printLog(message: "[DATABSE] Deleted subject: ${subject.toString()}");
  }

  SubjectEntity _dbToSubjectEntity(dynamic row) {
    return SubjectEntity(
      subjectId: intVal(row['subject_id']),
      label: strVal(row['label']),
      color: stringRGBToColor(strVal(row['color_code'])),
      archived: row['archived'] == 1,
    );
  }
}
