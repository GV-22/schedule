import 'constants.dart';
import 'db/init_db.dart';
import 'db/queries/subject_queries.dart';
import 'db/queries/task_queries.dart';
import 'src/app_shared_preferences_.dart';

late SubjectQueries subjectQueries;
late TaskQueries taskQueries;
late AppSharedPreferences appSharedPreferences;

Future<void> initContext() async {
  final db = await initDatabase(dbName);
  subjectQueries = SubjectQueries(db);
  taskQueries = TaskQueries(db);
  appSharedPreferences = AppSharedPreferences();
  await appSharedPreferences.initSharedPreferences();
}
