import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String message;
  const EmptyContent(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/empty_list.png",
            width: 150,
          ),
          const SizedBox(height: 20),
          Text(message),
        ],
      ),
    );
  }
}
