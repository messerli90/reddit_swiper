import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> fetchHistory() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList('history');
}
