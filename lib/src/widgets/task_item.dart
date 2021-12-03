import 'package:flutter/material.dart';
import '../../db/entities/task.dart';
import '../../helpers/converter_helpers.dart';
import '../views/task_editor.dart';
import '../../types.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;

  const TaskItem(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTimeStr = timeOfDayToString(task.startTime);
    final endTimeStr = timeOfDayToString(task.endTime);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 35,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 80,
          // color: Colors.yellow,
          alignment: Alignment.center,
          child: Text(
            "$startTimeStr - $endTimeStr",
            style: const TextStyle(fontSize: 12),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.circle,
              size: 14,
              color: task.subject.color,
            ),
            const SizedBox(width: 10),
            Text(
              task.subject.label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            )
          ],
        ),
        onTap: () => _showDialog(context, startTimeStr, endTimeStr),
      ),
    );
  }

  void _showDialog(
      BuildContext context, String startTimeStr, String endTimeStr) {
    final TextStyle timeStyle = TextStyle(
      color: task.subject.color,
      fontWeight: FontWeight.bold,
    );
    const TextStyle ftStyle = TextStyle(color: Colors.black54);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          task.subject.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.dayCode, style: ftStyle),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: ftStyle,
                children: [
                  const TextSpan(text: "From ", style: ftStyle),
                  TextSpan(text: startTimeStr, style: timeStyle),
                  const TextSpan(text: " to ", style: ftStyle),
                  TextSpan(text: endTimeStr, style: timeStyle),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(task.description ?? 'No description', style: ftStyle),
          ],
        ),
        actions: [
          _button(context, "Edit", ItemAction.edit),
          // _button(context, "Delete", ItemAction.delete),
          _button(context, "Close", ItemAction.close),
        ],
      ),
    );
  }

  Widget _button(BuildContext context, String label, ItemAction action) {
    return TextButton(
      child: Text(label),
      onPressed: () {
        switch (action) {
          case ItemAction.edit:
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushNamed(TaskEditor.routeName, arguments: task.taskId);
            break;
          case ItemAction.close:
            Navigator.of(context).pop();
            break;

          default:
            break;
        }
      },
    );
  }
}
