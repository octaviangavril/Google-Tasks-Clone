import 'dart:convert';
import 'package:google_tasks_clone/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/list_model.dart';

class WebStorageService implements StorageService {
  static const String listsKey = 'lists';

  @override
  Future<void> generateInitialLists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> initialLists = [
      {
        'id': 1,
        'name': 'My list',
        'tasks': [
          {
            'id': 1,
            'name': 'Task 1',
            'completed': false,
          },
        ],
      },
    ];
    await prefs.setString(listsKey, jsonEncode({'lists': initialLists}));
  }

  @override
  Future<void> saveLists(List<GoogleList> lists) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
    lists.map((list) => list.toJson()).toList();
    await prefs.setString(listsKey, jsonEncode({'lists': jsonList}));
  }

  @override
  Future<List<GoogleList>> getLists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? listsString = prefs.getString(listsKey);
    if (listsString == null) return [];
    final List<dynamic> decodedLists = jsonDecode(listsString)['lists'];
    return decodedLists.map((json) => GoogleList.fromJson(json)).toList();
  }
}
