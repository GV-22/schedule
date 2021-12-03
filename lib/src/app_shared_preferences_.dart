import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  int showTaskEditorBanner = 0;
  int showSubjectEditorBanner = 0;
  late SharedPreferences _sharedPreferences;

  Future<void> initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    showTaskEditorBanner = _sharedPreferences.getInt("showTaskEditorBanner") ?? 0;
    showSubjectEditorBanner = _sharedPreferences.getInt("showSubjectEditorBanner") ?? 0;
  }

  Future<void> setShowTaskEditorBanner(int value) async {
    await _sharedPreferences.setInt("showTaskEditorBanner", value);
    showTaskEditorBanner = value;
  }

  Future<void> setShowSubjectEditorBanner(int value) async {
    await _sharedPreferences.setInt("showSubjectEditorBanner", value);
    showSubjectEditorBanner = value;
  }

}
