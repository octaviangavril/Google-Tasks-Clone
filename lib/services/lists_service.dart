import 'package:flutter/foundation.dart';
import 'package:google_tasks_clone/model/list_model.dart';
import 'package:google_tasks_clone/services/storage_service.dart';
import 'package:google_tasks_clone/services/web_storage_service.dart';

import '../model/task_model.dart';
import 'mobile_storage_service.dart';

class ListService {
  static late StorageService _storageService;

  static Future<void> init() async {
    if (kIsWeb) {
      _storageService = WebStorageService();
    } else {
      _storageService = MobileStorageService();
    }
    await _storageService.generateInitialLists();
  }

  static Future<void> addList(String name) async {
    List<GoogleList> lists = await _storageService.getLists();
    lists.add(GoogleList(
      id: await _getNextListId(),
      name: name,
      tasks: [],
    ));
    _storageService.saveLists(lists);
  }

  static Future<void> updateList(int id, String name) async {
    List<GoogleList> lists = await _storageService.getLists();
    int index = lists.indexWhere((element) => element.id == id);
    if (index != -1) {
      lists[index].name = name;
      _storageService.saveLists(lists);
    }
  }

  static Future<void> deleteList(int id) async {
    List<GoogleList> lists = await _storageService.getLists();
    lists.removeWhere((element) => element.id == id);
    _storageService.saveLists(lists);
  }

  static Future<void> addTask(int id, String name) async {
    List<GoogleList> lists = await _storageService.getLists();
    lists.firstWhere((element) => element.id == id)
        .tasks.add(Task(
      id: await _getNextTaskId(id),
      name: name,
      completed: false,
    ));
    _storageService.saveLists(lists);
  }

  static Future<void> updateTask(int listId, int id, String? name, bool? completed) async {
    List<GoogleList> lists = await _storageService.getLists();
    if (name != null) {
      lists.firstWhere((element) => element.id == listId)
          .tasks.firstWhere((element) => element.id == id)
          .name = name;
    }
    if (completed != null) {
      lists.firstWhere((element) => element.id == listId)
          .tasks.firstWhere((element) => element.id == id)
          .completed = completed;
    }
    _storageService.saveLists(lists);
  }

  static Future<void> deleteTask(int listId, int id) async {
    List<GoogleList> lists = await _storageService.getLists();
    lists.firstWhere((element) => element.id == listId)
        .tasks.removeWhere((element) => element.id == id);
    _storageService.saveLists(lists);
  }

  static Future<int> _getNextListId() async {
    List<GoogleList> lists = await _storageService.getLists();
    return lists.isNotEmpty ? lists.last.id + 1 : 1;
  }

  static Future<int> _getNextTaskId(int id) async {
    List<GoogleList> lists = await _storageService.getLists();
    GoogleList list = lists.firstWhere((element) => element.id == id);
    return list.tasks.isNotEmpty ? list.tasks.last.id + 1 : 1;
  }

  static Future<List<GoogleList>> getLists() async {
    return await _storageService.getLists();
  }
}
