import 'package:flutter/material.dart';
import 'home_view.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_material_banner.dart';
import '../widgets/lang_selector.dart';
import '../../types.dart';

class SettingsView extends StatelessWidget {
  static const String routeName = "/settings";
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.zero,
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text(
                    "Delete all data",
                    style: TextStyle(color: Colors.red),
                  ),
                  value: ItemAction.delete,
                ),
              ];
            },
            onSelected: (ItemAction value) {
              switch (value) {
                case ItemAction.delete:
                  // _delete();
                  break;
                default:
                  break;
              }
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomMaterialBanner(
              "Setting features are coming soon",
              [
                TextButton(
                  child: const Text("Go it!"),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(HomeView.routeName),
                ),
              ],
            ),
            const LangSelector(),
            const Divider(),
            _buildBtn(
              Icons.cloud_upload_outlined,
              "Export your data",
              () {},
            ),
            _buildBtn(
              Icons.cloud_download_outlined,
              "Import data",
              () {},
            ),
            const Divider(),
            _buildBtn(
              Icons.reviews_outlined,
              "Send a review",
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(
    IconData icon,
    String label,
    void Function() handler, {
    Color? color,
  }) {
    return ListTile(
      // contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      // subtitle: Text("English"),
      trailing: Icon(Icons.chevron_right_outlined, color: color),
    );
  }
}
