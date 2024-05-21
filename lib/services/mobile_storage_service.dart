import 'dart:convert';
import 'dart:io';
import 'package:google_tasks_clone/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';

import '../model/list_model.dart';

class MobileStorageService implements StorageService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/lists.json');
  }

  @override
  Future<void> generateInitialLists() async {
    final File file = await _getLocalFile();
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
    await file.writeAsString(jsonEncode({'lists': initialLists}));
  }

  @override
  Future<void> saveLists(List<GoogleList> lists) async {
    final File file = await _getLocalFile();
    final List<Map<String, dynamic>> jsonList =
    lists.map((list) => list.toJson()).toList();
    await file.writeAsString(jsonEncode({'lists': jsonList}));
  }

  @override
  Future<List<GoogleList>> getLists() async {
    try {
      final File file = await _getLocalFile();
      final String contents = await file.readAsString();
      final List<dynamic> decodedLists = jsonDecode(contents)['lists'];
      return decodedLists.map((json) => GoogleList.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
