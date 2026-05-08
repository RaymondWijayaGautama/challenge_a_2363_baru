import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_a_2363/database/sql_helper.dart';
import 'package:gd6_a_2363/entity/employee.dart';
import 'package:gd6_a_2363/entity/inputPage.dart';
import 'package:gd6_a_2363/entity/manager_page.dart'; // Import Manager Page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set halamannya ke MainNavigation yang ada Navbar-nya
      home: const MainNavigation(), 
    );
  }
}

// ================= BOTTOM NAVIGATION BAR (SOAL 1) =================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List halaman untuk pindah-pindah tab
  static const List<Widget> _widgetOptions = <Widget>[
    EmployeePage(),
    ManagerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Managers',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ================= EMPLOYEE PAGE (DARI HOMEPAGE LAMA) =================
class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<Map<String, dynamic>> employee = [];

  void refresh() async {
    final data = await SQLHelper.getEmployees();
    setState(() {
      employee = data;
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
        title: const Text("EMPLOYEE"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputPage(
                    title: 'INPUT EMPLOYEE',
                    id: null,
                    name: null,
                    email: null,
                  ),
                ),
              ).then((_) => refresh());
            },
          ),
          IconButton(icon: const Icon(Icons.clear), onPressed: () async {})
        ],
      ),
      body: ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(employee[index]['id']),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputPage(
                          title: 'INPUT EMPLOYEE',
                          id: employee[index]['id'],
                          name: employee[index]['name'],
                          email: employee[index]['email'],
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
                    await deleteEmployee(employee[index]['id']);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(employee[index]['name']),
              subtitle: Text(employee[index]['email']),
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refresh();
  }
}