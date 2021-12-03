import 'package:flutter/material.dart';

class AppElevatedBtn extends StatelessWidget {
  final String label;
  final Function handler;

  const AppElevatedBtn(this.label, this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: FittedBox(
        child: ElevatedButton(
          onPressed: () => handler(),
          child: const Text("Save"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
