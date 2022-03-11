import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String _ddl = '''
drop table if exists s_task;
drop table if exists s_subject;

create table s_subject ( 
  subject_id integer primary key autoincrement,
  label varchar(200) not null,
  color_code varchar(6),
  archived tinyint(1) not null default 0,
  ts timestamp not null default current_timestamp
);

create table s_task (
  task_id integer primary key autoincrement, 
  subject_id integer not null references s_subject (subject_id),
  day_code varchar(20) not null,
  description text,
  start_time varchar(100) not null,
  end_time varchar(100) not null,
  archived tinyint(1) not null default 0,
  ts timestamp not null default current_timestamp
);

''';

Future<Database> initDatabase(String dbName) async {
  // await deleteDatabase(join(await getDatabasesPath(), dbName));
  return await openDatabase(
    join(await getDatabasesPath(), dbName),
    version: 1, //dbSchemaVersion,
    onCreate: (db, version) async {
      await ddl(db);
    },
    // onUpgrade: (db, oldVersion, newVersion) async {
    //   await ddl(db);
    // },
    // onOpen: (db) async {
    //   await db.execute('PRAGMA foreign_keys = ON');
    // },
  );
}

Future<void> ddl(Database db) async {
  await db.transaction((tx) async {
    final splittedDdlString = _ddl.trim().split(';');
    for (final String query in splittedDdlString) {
      if (query.isNotEmpty) {
        await tx.execute(query.trim());
      }
    }
  });
}

/*
INSERT INTO s_subject("subject_id", "label", "color_code", "ts") VALUES ('1', 'Workout', '244-67-54', '2021-11-28 01:59:28');
INSERT INTO s_subject("subject_id", "label", "color_code", "ts") VALUES ('2', 'Game', '233-30-99', '2021-11-28 11:22:14');
INSERT INTO s_subject("subject_id", "label", "color_code", "ts") VALUES ('3', 'Rest', '156-39-176', '2021-11-28 11:22:27');
INSERT INTO s_subject("subject_id", "label", "color_code", "ts") VALUES ('8', 'New', '33-150-243', '2021-12-01 23:18:32');

INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('1', '1', 'monday', 'this is a description', '13:50', '14:55', '2021-11-28 14:13:00');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('2', '2', 'monday', '', '15:43', '15:55', '2021-11-28 15:44:02');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('3', '3', 'wednesday', 'rest before working', '15:44', '15:55', '2021-11-28 15:45:33');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('4', '1', 'monday', '', '16:07', '16:41', '2021-11-28 16:07:16');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('7', '1', 'wednesday', '', '06:30', '07:00', '2021-12-01 09:47:02');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('8', '3', 'thursday', '', '19:44', '19:55', '2021-12-01 19:44:37');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('9', '3', 'sunday', '', '19:44', '19:55', '2021-12-01 19:46:40');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('10', '1', 'sunday', '', '06:00', '06:30', '2021-12-01 20:00:12');
INSERT INTO s_task("task_id", "subject_id", "day_code", "description", "start_time", "end_time", "ts") VALUES ('11', '1', 'tuesday', '', '06:00', '06:30', '2021-12-01 20:00:22');
*/