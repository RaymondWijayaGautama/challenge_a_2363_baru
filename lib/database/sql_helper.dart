import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    // Membuat tabel employees
    await database.execute("""CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT
      )
      """);

    // MEMBUAT TABEL MANAGER (Ini yang sebelumnya kurang)
    await database.execute("""CREATE TABLE manager(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT,
        employee TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('employee.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // ================= CRUD EMPLOYEE =================
  // (Typo nama tabel 'employee' diubah jadi 'employees' agar sesuai dengan createTables)
  static Future<int> addEmployee(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.insert('employees', data); 
  }

  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await SQLHelper.db();
    return db.query('employees', orderBy: "id");
  }

  static Future<int> editEmployee(int id, String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email, 'id': id};
    return await db.update('employees', data, where: "id = $id");
  }

  static Future<int> deleteEmployee(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('employees', where: "id = $id");
  }

  // ================= CRUD MANAGER =================
  static Future<int> addManager(String name, String email, String employee) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email, 'employee': employee};
    return await db.insert('manager', data);
  }

  static Future<List<Map<String, dynamic>>> getManagers() async {
    final db = await SQLHelper.db();
    return db.query('manager', orderBy: "id");
  }

  static Future<int> editManager(int id, String name, String email, String employee) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email, 'employee': employee};
    return await db.update('manager', data, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteManager(int id) async {
    final db = await SQLHelper.db();
    await db.delete('manager', where: "id = ?", whereArgs: [id]);
  }
}