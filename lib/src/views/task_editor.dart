import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../context.dart';
import '../../db/entities/subject.dart';
import '../../db/entities/task.dart';
import '../../helpers/converter_helpers.dart';
import '../../helpers/utils.dart';
import '../../providers/data_provider.dart';
import '../ui_utils.dart';
import 'subject_editor.dart';
import '../widgets/app_bar_btn.dart';
import '../widgets/custom_material_banner.dart';
import '../widgets/subject_item.dart';
import '../../types.dart';

class TaskEditor extends StatefulWidget {
  static const String routeName = "/task-editor";

  const TaskEditor({Key? key}) : super(key: key);

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  bool _addMode = true;
  TaskEntity? _task;
  SubjectEntity? _subject;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _initialized = false;

  final _formState = GlobalKey<FormState>();
  final _descriptionInputController = TextEditingController();
  final _testInputController = TextEditingController();
  final _subjectInputController = TextEditingController();
  final _dayInputController = TextEditingController();
  final _startTimeInputController = TextEditingController();
  final _endTimeInputController = TextEditingController();

  @override
  void dispose() {
    _descriptionInputController.dispose();
    _testInputController.dispose();
    _subjectInputController.dispose();
    _dayInputController.dispose();
    _startTimeInputController.dispose();
    _endTimeInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _initData(ModalRoute.of(context)?.settings.arguments as int?);
    }
    const double size = 20;

    return Scaffold(
      appBar: AppBar(
        title: Text(_addMode ? "Add new task" : "Edit task"),
        actions: [
          if (_task == null || !_task!.archived) AppElevatedBtn("Save", _save),
          if (!_addMode) _buildPopupMenu()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (appSharedPreferences.showTaskEditorBanner == 1)
              CustomMaterialBanner(
                "You have successfully added a task."
                " Note that you can add more before exiting the screen",
                [
                  TextButton(
                    child: const Text('Got it!'),
                    onPressed: _hideBanner,
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormInput(
                      "Pick a subject",
                      Selectable.subject,
                      Icons.subject_outlined,
                      _subjectInputController,
                    ),
                    const SizedBox(height: size),
                    _buildFormInput(
                      "Pick a day",
                      Selectable.day,
                      Icons.calendar_today_outlined,
                      _dayInputController,
                    ),
                    const SizedBox(height: size),
                    _buildFormInput(
                      "Start",
                      Selectable.startTime,
                      Icons.watch_later_outlined,
                      _startTimeInputController,
                    ),
                    const SizedBox(height: size),
                    _buildFormInput(
                      "End",
                      Selectable.endTime,
                      Icons.watch_later_outlined,
                      _endTimeInputController,
                    ),
                    const SizedBox(height: size),
                    TextFormField(
                      controller: _descriptionInputController,
                      decoration: inputDecoration("Description"),
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      cursorColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<ItemAction> _buildPopupMenu() {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text(_task!.archived ? 'Unarchive' : 'Archive'),
            value: ItemAction.archive,
          ),
          const PopupMenuItem(
            child: Text("Delete"),
            value: ItemAction.delete,
          ),
        ];
      },
      onSelected: (ItemAction value) {
        switch (value) {
          case ItemAction.delete:
            _delete();
            break;
          case ItemAction.archive:
            _setArchived();
            break;
          default:
            break;
        }
      },
    );
  }

  void _initData(int? taskId) {
    if (taskId == null) return;

    _addMode = false;
    _task = Provider.of<DataProvider>(context).getTaskEntity(taskId);

    if (_task == null) return;

    _subjectInputController.text = _task!.subject.label;
    _descriptionInputController.text = _task?.description ?? "";
    _dayInputController.text = toCapitalize(_task!.dayCode);
    _startTimeInputController.text =
        "Start ${timeOfDayToString(_task!.startTime)}";
    _endTimeInputController.text = "End ${timeOfDayToString(_task!.endTime)}";

    _subject = _task!.subject;
    _endTime = _task!.endTime;
    _startTime = _task!.startTime;
    _initialized = true;
  }

  bool _isCorrectTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    return toDouble(startTime) < toDouble(endTime);
  }

  Future<void> _save() async {
    final isValidate = _formState.currentState?.validate();
    // print("*********** _task form isValidate $isValidate");
    if (isValidate == null || !isValidate) return;

    if (_startTime != null && _endTime != null) {
      if (!_isCorrectTimeRange(_startTime!, _endTime!)) {
        UiUtils.customAltertDialog(
          context,
          "Note",
          "The end time must be after the start time",
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            )
          ],
        );
        return;
      }
    }

    _formState.currentState?.save();

    try {
      final desc = _descriptionInputController.text.trim();
      if (_task != null) {
        await Provider.of<DataProvider>(context, listen: false).updateTask(
          TaskEntity(
            taskId: _task!.taskId,
            subject: _subject!,
            description: desc.isEmpty ? null : desc,
            startTime: _startTime!,
            endTime: _endTime!,
            dayCode: _dayInputController.text.toLowerCase(),
            archived: _task!.archived,
          ),
        );
        UiUtils.customSnackBar(
            context, "The task has been successfully updated.");
      } else {
        await Provider.of<DataProvider>(context, listen: false).insertTask(
          TaskToAddEntity(
            subject: _subject!,
            description: desc.isEmpty ? null : desc,
            startTime: _startTime!,
            endTime: _endTime!,
            dayCode: _dayInputController.text.toLowerCase(),
          ),
        );
        UiUtils.customSnackBar(
            context, "The task has been successfully added.");

        if (appSharedPreferences.showTaskEditorBanner == 0) {
          await appSharedPreferences.setShowTaskEditorBanner(1);
          setState(() {});
        }
      }
    } catch (e) {
      printLog(
          message: "*********** [DATABASE] error while saving task data $e");
      // rethrow;
    }
  }

  Future<void> _setArchived() async {
    if (_task == null) {
      UiUtils.customSnackBar(context, "Invalid archive opertaion");
      return;
    }

    final tmpTask = TaskEntity(
      taskId: _task!.taskId,
      subject: _subject!,
      description: _task!.description,
      startTime: _startTime!,
      endTime: _endTime!,
      dayCode: _dayInputController.text,
      archived: !_task!.archived,
    );
    await Provider.of<DataProvider>(context, listen: false).updateTask(tmpTask);
    UiUtils.customSnackBar(
      context,
      "The task has been successfully ${_task!.archived ? 'unarchived' : 'archived'}.",
    );
    if (_task!.archived) {
      setState(() {});
    } else {
      Navigator.of(context).pop();
    }
  }

  // void _resetForm() {
  //   _descriptionInputController.text = "";
  //   _testInputController.text = "";
  //   _subjectInputController.text = "";
  //   _dayInputController.text = "";
  //   _startTimeInputController.text = "";
  //   _endTimeInputController.text = "";
  // }

  Future<void> _delete() async {
    if (_task == null) return;

    try {
      if (await UiUtils.showConfirmationDialog(context, "Delete this task ?")) {
        await Provider.of<DataProvider>(context, listen: false)
            .deleteTask(_task!);

        UiUtils.customSnackBar(
            context, "The task has been successfully deleted.");
        Navigator.of(context).pop();
      }
    } catch (e) {
      printLog(message: "[DATABASE] error while deleting the task $_task $e");
    }
  }

  Future<void> _hideBanner() async {
    await appSharedPreferences.setShowTaskEditorBanner(-1);
    setState(() {});
  }

  Widget _buildFormInput(
    String label,
    Selectable selectable,
    IconData icon,
    TextEditingController _controller,
  ) {
    return TextFormField(
      controller: _controller,
      decoration: inputDecoration(label, icon: icon),
      keyboardType: TextInputType.text,
      cursorColor: Theme.of(context).colorScheme.primary,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill this field";
        }
        return null;
      },
      onTap: () {
        switch (selectable) {
          case Selectable.subject:
            _bottomSheet(Selectable.subject);
            break;
          case Selectable.day:
            _bottomSheet(Selectable.day);
            break;
          case Selectable.startTime:
          case Selectable.endTime:
            _showTimePicker(selectable);
            break;
          default:
            throw "Invalid selectable provided $selectable";
        }
      },
    );
  }

  InputDecoration inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: const TextStyle(color: Colors.black54),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      prefixIcon: icon == null ? null : Icon(icon, size: 20),
      border: const OutlineInputBorder(),
    );
  }

  Future<void> _showTimePicker(Selectable selectable) async {
    if (selectable != Selectable.startTime &&
        selectable != Selectable.endTime) {
      throw "Expected startTime or endTime selectable. Found: $selectable";
    }

    TimeOfDay? choosed = await showTimePicker(
      context: context,
      initialTime: selectable == Selectable.startTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );

    if (selectable == Selectable.startTime) {
      _startTime = choosed ?? _startTime;
      _startTimeInputController.text = "Start ${timeOfDayToString(_startTime)}";
      // print("*********** _startime: ${_startTimeInputController.text}");
    } else {
      _endTime = choosed ?? _endTime;
      _endTimeInputController.text = "End ${timeOfDayToString(_endTime)}";
      // print("*********** _endTime: ${_endTimeInputController.text}");
    }
  }

  Future<void> _bottomSheet(Selectable selectable) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              selectable == Selectable.subject
                  ? "Pick a subject"
                  : "Pick a day",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          selectable == Selectable.subject ? _selectSubject() : _selectDay(),
        ],
      ),
    );
  }

  Widget _selectSubject() {
    final _subjects =
        Provider.of<DataProvider>(context, listen: false).subjects;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Add new subject"),
          onTap: () {
            Navigator.of(context)
              ..pop()
              ..push(
                MaterialPageRoute(
                  builder: (_) => const SubjectEditor(),
                  fullscreenDialog: true,
                ),
              );
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _subjects.length,
          itemBuilder: (_, int index) {
            final subject = _subjects[index];
            return SubjectIem(
              subject,
              () {
                _subject = subject;
                _subjectInputController.text = _subject!.label;
                Navigator.of(context).pop();
              },
              canArchive: false,
              canDelete: false,
            );
          },
        ),
      ],
    );
  }

  Widget _selectDay() {
    return Expanded(
      child: ListView.builder(
        itemCount: days.length,
        itemBuilder: (BuildContext context, int index) {
          final day = toCapitalize(days[index]);
          return ListTile(
            leading: Icon(
              Icons.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(day),
            onTap: () {
              _dayInputController.text = day;
              Navigator.of(context).pop();
            },
            // contentPadding: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
