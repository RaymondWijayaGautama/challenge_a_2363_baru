import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_a_2363/database/sql_helper.dart';
import 'package:gd6_a_2363/entity/input_manager.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  List<Map<String, dynamic>> manager = [];

  void refresh() async {
    final data = await SQLHelper.getManagers();
    setState(() {
      manager = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Managers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputManagerPage(
                    title: 'INPUT MANAGER',
                    id: null,
                    name: null,
                    email: null,
                    employee: null,
                  ),
                ),
              ).then((_) => refresh());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: manager.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(manager[index]['id']),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputManagerPage(
                          title: 'EDIT MANAGER',
                          id: manager[index]['id'],
                          name: manager[index]['name'],
                          email: manager[index]['email'],
                          employee: manager[index]['employee'],
                        ),
                      ),
                    ).then((_) => refresh());
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.update,
                  label: 'Update',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await deleteManager(manager[index]['id']);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(manager[index]['name']),
              // Menampilkan email di atas, employee di bawahnya persis gambar soal
              subtitle: Text('${manager[index]['email']}\n${manager[index]['employee']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteManager(int id) async {
    await SQLHelper.deleteManager(id);
    refresh();
  }
}