import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../db/entities/subject.dart';
import '../../helpers/utils.dart';
import '../../providers/data_provider.dart';
import '../ui_utils.dart';
import '../views/subject_editor.dart';
import '../../types.dart';

class SubjectIem extends StatelessWidget {
  final SubjectEntity _subject;
  final Function _handler;
  final bool canArchive;
  final bool canDelete;

  const SubjectIem(
    this._subject,
    this._handler, {
    this.canArchive = true,
    this.canDelete = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 16),
      onTap: () => _handler(),
      leading: Icon(Icons.circle, color: _subject.color),
      title: Text(_subject.label),
      trailing: _buildPopupMenu(context),
    );
  }

  PopupMenuButton<ItemAction> _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,  
      itemBuilder: (context) {
        return [
          if (!_subject.archived)
            const PopupMenuItem(
              child: Text("Edit"),
              value: ItemAction.edit,
            ),
          if (canArchive)
            PopupMenuItem(
              child: Text(_subject.archived ? "Unarchive" : "Archive"),
              value: ItemAction.archive,
            ),
          if (canDelete)
            const PopupMenuItem(
              child: Text("Delete"),
              value: ItemAction.delete,
            ),
        ];
      },
      onSelected: (ItemAction value) {
        switch (value) {
          case ItemAction.edit:
            Navigator.of(context)
                .pushNamed(SubjectEditor.routeName, arguments: _subject);
            break;
          case ItemAction.archive:
            _setArchived(context);
            break;
          case ItemAction.delete:
            _delete(context);
            break;
          default:
            break;
        }
      },
    );
  }

  Future<void> _delete(BuildContext context) async {
    try {
      await Provider.of<DataProvider>(context, listen: false)
          .deleteSubject(_subject);

      UiUtils.customSnackBar(
          context, "The subject  has been successfully deleted.");
    } catch (e) {
      printLog(
          message: "[DATABASE] error while deleting the subject $_subject $e");
    }
  }

  Future<void> _setArchived(BuildContext context) async {
    try {
      await Provider.of<DataProvider>(context, listen: false).updateSubject(
        SubjectEntity(
          subjectId: _subject.subjectId,
          label: _subject.label,
          color: _subject.color,
          archived: !_subject.archived,
        ),
      );

      UiUtils.customSnackBar(
        context,
        "The subject has been successfully ${_subject.archived ? 'unarchived' : 'archived'}.",
      );
    } catch (e) {
      printLog(
          message: "[DATABASE] error while archiving the subject $_subject $e");
    }
  }
}
