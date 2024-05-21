import '../model/list_model.dart';

abstract class StorageService {
  Future<void> generateInitialLists();
  Future<void> saveLists(List<GoogleList> lists);
  Future<List<GoogleList>> getLists();
}
