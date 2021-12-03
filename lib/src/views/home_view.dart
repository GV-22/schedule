import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../db/entities/task.dart';
import '../../helpers/utils.dart';
import '../../providers/data_provider.dart';
import 'task_editor.dart';
import '../widgets/app_drawer.dart';
import '../widgets/empty_content.dart';
import '../widgets/task_item.dart';

class HomeView extends StatefulWidget {
  static const String routeName = "/";
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showArchivedTasks = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final tasks = dataProvider.tasks
        .where((t) => _showArchivedTasks ? t.archived : !t.archived);

    return Scaffold(
      appBar: AppBar(
        title: Text(_showArchivedTasks ? "Archived tasks" : "Tasks"),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.zero,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: _showArchivedTasks,
                  child: Text(_showArchivedTasks ? "Tasks" : "Archived tasks"),
                ),
              ];
            },
            onSelected: (bool val) {
              setState(() => _showArchivedTasks = !val);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: tasks.isEmpty
          ? EmptyContent(
              _showArchivedTasks
                  ? "There is no archived task."
                  : "There is no task.",
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: days.length,
                itemBuilder: (BuildContext context, int index) {
                  final _day = days[index];
                  final _dayTasks =
                      tasks.where((ts) => ts.dayCode == _day).toList();

                  _dayTasks.sort((a, b) =>
                      toDouble(a.startTime).compareTo(toDouble(b.startTime)));

                  return _dailyTasks(_day, _dayTasks);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext ctx) => const TaskEditor(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }

  Widget _dailyTasks(String day, List<TaskEntity> _dayTasks) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toCapitalize(day),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          _dayTasks.isEmpty
              ? const SizedBox(height: 40)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _dayTasks.map((task) => TaskItem(task)).toList(),
                )
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    await Provider.of<DataProvider>(context, listen: false).retrieveSubjects();
    await Provider.of<DataProvider>(context, listen: false).retrieveTasks();
  }
}
// Row(
//   children: [
//     Text(
//       "${task.startTime} - ${task.endTime}",
//       style: const TextStyle(fontSize: 12),
//     ),
//     const SizedBox(width: 10),
//     Icon(
//       Icons.circle,
//       size: 12,
//       color: colorScheme.secondary,
//     ),
//     const SizedBox(width: 10),
//     Text(
//       task.subject.label,
//       style: const TextStyle(fontWeight: FontWeight.bold),
//     )
//   ],
// ),