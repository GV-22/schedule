import 'package:flutter/material.dart';

import '../../constants.dart';
import '../views/home_view.dart';
import '../views/settings_view.dart';
import '../views/subjects_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  String getCurrentRouteName(context) {
    String currentRouteName = "/";

    Navigator.of(context).popUntil((route) {
      // print("pop unitl");
      if (route.settings.name != null) {
        currentRouteName = route.settings.name!;
      }

      return true;
    });

    return currentRouteName;
  }

  @override
  Widget build(BuildContext context) {
    String currentRoute = getCurrentRouteName(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(appName),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(height: 20),
          _menuItem(
            context,
            Icons.task_outlined,
            "Tasks",
            HomeView.routeName,
            currentRoute == HomeView.routeName,
          ),
          const Divider(),
          _menuItem(
            context,
            Icons.subject_outlined,
            "Subjects",
            SubjectsView.routeName,
            currentRoute == SubjectsView.routeName,
          ),
          const Divider(),
          _menuItem(
            context,
            Icons.settings,
            "Settings",
            SettingsView.routeName,
            currentRoute == SettingsView.routeName,
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String text,
    String routeName,
    bool selected,
  ) {
    final color = selected
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(icon, size: 20, color: color),
      // selected: selected,
      title: Text(text, style: TextStyle(color: color)),
      onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
    );
  }
}
