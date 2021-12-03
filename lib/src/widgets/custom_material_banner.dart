import 'package:flutter/material.dart';

class CustomMaterialBanner extends StatelessWidget {
  final String message;
  final List<Widget> actions;

  const CustomMaterialBanner(this.message, this.actions, {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MaterialBanner(
        padding: const EdgeInsets.all(15),
        forceActionsBelow: true,
        content: Text(message),
        leading: const Icon(Icons.info_outline),
        backgroundColor: const Color(0xFFE0E0E0),
        actions: actions,
      ),
    );
  }
}
