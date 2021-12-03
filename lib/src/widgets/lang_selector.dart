import 'package:flutter/material.dart';

class LangSelector extends StatelessWidget {
  const LangSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.language),
      title: Text("Language"),
      subtitle: Text("English"),
      trailing: Icon(Icons.chevron_right_outlined),
    );
  }
}
