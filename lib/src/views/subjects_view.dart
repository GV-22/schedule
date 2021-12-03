import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import 'subject_editor.dart';
import '../widgets/app_drawer.dart';
import '../widgets/empty_content.dart';
import '../widgets/subject_item.dart';

class SubjectsView extends StatefulWidget {
  static const routeName = "/subjects";
  const SubjectsView({Key? key}) : super(key: key);

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  bool _showArchivedSubjects = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showArchivedSubjects ? "Archived subjects" : "Subjects",
        ),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.zero,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: _showArchivedSubjects,
                  child: Text(
                    _showArchivedSubjects ? "Subjects" : "Archived subjects",
                  ),
                ),
              ];
            },
            onSelected: (bool val) {
              setState(() => _showArchivedSubjects = !val);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<DataProvider>(
        builder: (context, consumerDataProvider, _) {
          final subjects = consumerDataProvider.subjects
              .where((s) => _showArchivedSubjects ? s.archived : !s.archived);
          // .toList();

          return subjects.isEmpty
              ? EmptyContent(
                  _showArchivedSubjects
                      ? "There is no archived subject."
                      : "There is no subject.",
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjects.length,
                  itemBuilder: (_, int index) => SubjectIem(
                    subjects.elementAt(index),
                    () {},
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext ctx) => const SubjectEditor(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
