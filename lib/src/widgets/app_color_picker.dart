import 'package:flutter/material.dart';

const List<Color> colors = [
  Color(0xfff44336),
  Color(0xffe91e63),
  Color(0xff9c27b0),
  Color(0xff673ab7),
  Color(0xff3f51b5),
  Color(0xff2196f3),
  Color(0xff03a9f4),
  Color(0xff00bcd4),
  Color(0xff009688),
  Color(0xff4caf50),
  Color(0xff8bc34a),
  Color(0xffcddc39),
  Color(0xffffeb3b),
  Color(0xffffc107),
  Color(0xffff9800),
  Color(0xffff5722),
  Color(0xff795548),
  Color(0xff9e9e9e),
  Color(0xff607d8b),
  Color(0xff000000),
  Color(0x8a000000)
];

class AppColorPicker extends StatelessWidget{
  final Color _pickedColor;
  final void Function(Color) _onColorPick;

  const AppColorPicker({
    required Color pickedColor,
    required void Function(Color) onColorPick,
    Key? key,
  })  : _pickedColor = pickedColor,
        _onColorPick = onColorPick,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: colors.map(_colorItem).toList(),
      ),
    );
  }

  Widget _colorItem(Color color) {
    return GestureDetector(
      onTap: () => _onColorPick(color),
      child: Material(
        elevation: 4,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: color,
          child: color == _pickedColor
              ? const Icon(Icons.check, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
