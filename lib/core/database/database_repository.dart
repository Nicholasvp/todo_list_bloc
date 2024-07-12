import 'package:shared_preferences/shared_preferences.dart';

class DatabaseRepository {
  void saveData(List<String> todos) async {
    final prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < todos.length; i++) {
      prefs.setString('$i', todos[i]);
    }
  }

  Future<List<String>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('todo') ?? [];
  }

  void removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
