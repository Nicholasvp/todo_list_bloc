import 'package:shared_preferences/shared_preferences.dart';

class DatabaseRepository {
  Future<void> saveData(List<String> todos) async {
    final prefs = await SharedPreferences.getInstance();

    bool res = await prefs.setStringList('todos', todos);
    if (!res) {
      throw Exception('Failed to save data');
    }
  }

  Future<List<String>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('todos') ?? [];
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
