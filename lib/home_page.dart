import 'package:flutter/material.dart';
import 'package:google_tasks_clone/model/list_model.dart';
import 'package:google_tasks_clone/services/lists_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<GoogleList> myLists = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    initServicesAndUploadLists();
  }

  Future<void> initServicesAndUploadLists() async {
    await ListService.init();
    await uploadLists();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> initServices() async {
    await ListService.init();
  }

  Future<void> uploadLists() async {
    final lists = await ListService.getLists();
    setState(() {
      myLists.clear();
      myLists.addAll(lists);
      _tabController?.dispose();
      _tabController = TabController(length: myLists.length + 1, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Tasks'),
        ),
      ),
      body: myLists != []
          ? DefaultTabController(
              length: myLists.length + 1,
              child: Column(
                children: [
                  if (_tabController != null)
                    TabBar(
                      controller: _tabController,
                      tabs:
                          myLists.map((list) => Tab(text: list.name)).toList() +
                              [const Tab(text: '+ New List')],
                      onTap: (index) {
                        setState(() {
                          _tabController!.index = index;
                        });
                      },
                    ),
                  if (_tabController != null)
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: myLists.map((list) {
                              return list.tasks.isEmpty
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              size: 100.0),
                                          Text('No tasks yet'),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: MediaQuery.of(context)
                                                  .size
                                                  .width >
                                              600
                                          ? EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4)
                                          : const EdgeInsets.all(0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: list.tasks
                                                  .where(
                                                      (task) => !task.completed)
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final task = list.tasks
                                                    .where((task) =>
                                                        !task.completed)
                                                    .elementAt(index);
                                                return ListTile(
                                                  title: Text("- ${task.name}"),
                                                  trailing: IconButton(
                                                    icon: const Icon(
                                                        Icons.circle_outlined),
                                                    tooltip:
                                                        'Mark as completed',
                                                    onPressed: () async {
                                                      await ListService
                                                          .updateTask(
                                                              list.id,
                                                              task.id,
                                                              null,
                                                              true);
                                                      int tabIndex =
                                                          _tabController!.index;
                                                      await uploadLists();
                                                      setState(() {
                                                        _tabController!.index =
                                                            tabIndex;
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            list.tasks
                                                    .where((task) =>
                                                        task.completed)
                                                    .isNotEmpty
                                                ? ExpansionTile(
                                                    title: Text(
                                                        "Completed (${list.tasks.where((task) => task.completed).length})",
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: list.tasks
                                                            .where((task) =>
                                                                task.completed)
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final task = list
                                                              .tasks
                                                              .where((task) =>
                                                                  task.completed)
                                                              .elementAt(index);
                                                          return Padding(
                                                              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                                                          child: Text(
                                                            task.name,
                                                            style:
                                                            const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                              decorationThickness:
                                                              2,
                                                            ),
                                                          ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ]));
                            }).toList() +
                            [
                              Padding(
                                  padding:
                                      MediaQuery.of(context).size.width > 600
                                          ? EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4)
                                          : const EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          hintText: 'Enter list name',
                                        ),
                                        onSubmitted: (value) async {
                                          if (value.isNotEmpty) {
                                            await ListService.addList(value);
                                            await uploadLists();
                                            setState(() {
                                              _tabController!.index =
                                                  myLists.length - 1;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  )
                              ),
                            ],
                      ),
                    ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _tabController != null &&
              _tabController!.index < myLists.length
          ? BottomAppBar(
              child: Padding(
              padding: MediaQuery.of(context).size.width > 600
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 4)
                  : const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Edit List'),
                                content: TextField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Current list name: ${myLists[_tabController!.index].name}',
                                  ),
                                  onSubmitted: (value) async {
                                    if (value.isNotEmpty) {
                                      await ListService.updateList(
                                          myLists[_tabController!.index].id,
                                          value);
                                      int tabIndex = _tabController!.index;
                                      await uploadLists();
                                      setState(() {
                                        _tabController!.index = tabIndex;
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                        tooltip: 'Rename List',
                      ),
                      myLists[_tabController!.index]
                              .tasks
                              .where((element) => element.completed)
                              .isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Delete all completed tasks'),
                                      content: const Text(
                                          'Are you sure you want to delete all completed tasks?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            for (final task in myLists[
                                                    _tabController!.index]
                                                .tasks) {
                                              if (task.completed) {
                                                await ListService.deleteTask(
                                                    myLists[_tabController!
                                                            .index]
                                                        .id,
                                                    task.id);
                                              }
                                            }
                                            int tabIndex =
                                                _tabController!.index;
                                            await uploadLists();
                                            setState(() {
                                              _tabController!.index = tabIndex;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                              'Delete all completed tasks'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.restore_outlined),
                              tooltip: 'Delete all completed tasks',
                            )
                          : const SizedBox(),
                      _tabController!.index != 0
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete List'),
                                      content: const Text(
                                          'Are you sure you want to delete this list?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await ListService.deleteList(
                                                myLists[_tabController!.index]
                                                    .id);
                                            int tabIndex =
                                                _tabController!.index - 1;
                                            await uploadLists();
                                            setState(() {
                                              _tabController!.index = tabIndex;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete List'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete List',
                            )
                          : const SizedBox(),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Add Task'),
                            content: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter task name',
                              ),
                              onSubmitted: (value) async {
                                if (value.isNotEmpty) {
                                  await ListService.addTask(
                                      myLists[_tabController!.index].id, value);
                                  int tabIndex = _tabController!.index;
                                  await uploadLists();
                                  setState(() {
                                    _tabController!.index = tabIndex;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add_circle),
                    tooltip: 'Add Task',
                  ),
                ],
              ),
            ))
          : null,
    );
  }
}
