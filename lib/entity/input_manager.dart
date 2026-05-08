import 'package:flutter/material.dart';
import 'package:gd6_a_2363/database/sql_helper.dart';

class InputManagerPage extends StatefulWidget {
  const InputManagerPage({
    super.key,
    required this.title,
    required this.id,
    required this.name,
    required this.email,
    required this.employee, // Field tambahan
  });

  final String? title, name, email, employee;
  final int? id;

  @override
  State<InputManagerPage> createState() => _InputManagerPageState();
}

class _InputManagerPageState extends State<InputManagerPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerEmployee = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerName.text = widget.name!;
      controllerEmail.text = widget.email!;
      controllerEmployee.text = widget.employee!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "INPUT MANAGER"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerEmail,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerEmployee,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nama Employee',
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              if (widget.id == null) {
                await SQLHelper.addManager(
                    controllerName.text, controllerEmail.text, controllerEmployee.text);
              } else {
                await SQLHelper.editManager(widget.id!, controllerName.text,
                    controllerEmail.text, controllerEmployee.text);
              }

              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}