import 'package:flutter/material.dart';
import 'package:my_week_schedule/context.dart';
import 'package:my_week_schedule/src/widgets/custom_material_banner.dart';
import 'package:provider/provider.dart';
import '../../db/entities/subject.dart';
import '../../helpers/utils.dart';
import '../../providers/data_provider.dart';
import '../ui_utils.dart';
import '../widgets/app_bar_btn.dart';
import '../widgets/app_color_picker.dart';

class SubjectEditor extends StatefulWidget {
  static const String routeName = "/subject-editor";

  const SubjectEditor({Key? key}) : super(key: key);

  @override
  State<SubjectEditor> createState() => _SubjectEditorState();
}

class _SubjectEditorState extends State<SubjectEditor> {
  final _formState = GlobalKey<FormState>();
  final TextEditingController _labelInputController = TextEditingController();
  Color _pickedColor = const Color(0xFF42244A);

  @override
  void dispose() {
    _labelInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubjectEntity? _subject =
        ModalRoute.of(context)!.settings.arguments as SubjectEntity?;
    final bool _addMode = _subject == null;
    _labelInputController.text =
        _subject == null ? _labelInputController.text : _subject.label;
    // _pickedColor = stringRGBToColor(_subject)

    return Scaffold(
      appBar: AppBar(
        title: Text(_addMode ? "Add new subject" : "Edit subject"),
        actions: [
          AppElevatedBtn("Save", () => _save(context, _subject)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (appSharedPreferences.showSubjectEditorBanner == 1)
              CustomMaterialBanner(
                "You have successfully added a subject."
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
                    TextFormField(
                      controller: _labelInputController,
                      decoration: const InputDecoration(
                        labelText: "Label",
                        helperText: "Eg: Workout, Rest, Game, Work, etc..",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      textInputAction: TextInputAction.unspecified,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter the label";
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, color: _pickedColor),
                      title: const Text("Pick a color"),
                      contentPadding: EdgeInsets.zero,
                      onTap: _colorPicker,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _hideBanner() async {
    await appSharedPreferences.setShowSubjectEditorBanner(-1);
    setState(() {});
  }

  void _changeColor(Color color) {
    // _pickedColor = color;
    //print("Selected color :$color :: _pickedColor ${_pickedColor.value}");
    Navigator.of(context).pop();
    setState(() => _pickedColor = color);
  }

  void _colorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext bCtx) {
        return AlertDialog(
          title: const Text(
            "Pick a color",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          content: AppColorPicker(
            pickedColor: _pickedColor,
            onColorPick: _changeColor,
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future<void> _save(BuildContext context, SubjectEntity? subject) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final provided = _labelInputController.text.trim();
    final _tmp = dataProvider.getSubjectEntityByName(provided);

    if (_tmp != null) {
      UiUtils.customAltertDialog(
        context,
        "Note",
        "The subject $provided already exists.",
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ok"),
          )
        ],
      );
      return;
    }

    final isValidate = _formState.currentState?.validate();
    if (isValidate == null || !isValidate) return;

    _formState.currentState?.save();
    try {
      final String capitalized = toCapitalize(_labelInputController.text);
      if (subject != null) {
        await dataProvider.updateSubject(
          SubjectEntity(
            subjectId: subject.subjectId,
            label: capitalized,
            color: _pickedColor,
            archived: subject.archived,
          ),
        );
        UiUtils.customSnackBar(
          context,
          "The subject has been successfully updated.",
        );
      } else {
        await dataProvider.insertSubject(
          SubjectToAddEntity(label: capitalized, color: _pickedColor),
        );

        if (appSharedPreferences.showSubjectEditorBanner == 0) {
          await appSharedPreferences.setShowSubjectEditorBanner(1);
          setState(() {});
        }

        UiUtils.customSnackBar(
          context,
          "The subject $capitalized has been successfully added.",
        );
        setState(() => _pickedColor = const Color(0xFF42244A));
      }
    } catch (e) {
      printLog(
        message: "[DATABASE] error while saving _selectedSubject data $e",
      );
    }
  }
}
