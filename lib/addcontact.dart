import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerName, _controllerContactNumber;
  String? name, contactnumber;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerName = TextEditingController();
    _controllerContactNumber = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Add Contact'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  keyboardType: TextInputType.text,
                  onChanged: (String value) => setState(() {}),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone),
                title: TextFormField(
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  controller: _controllerContactNumber,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) => setState(() {}),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.symmetric(vertical: 16)),
                  ),
                  onPressed: () {
                    _addContact();
                  },
                  child: const Text('Add Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addContact() {
    if (name!.isEmpty) {
      setState(() => name = 'At Least 1 Person or Message Required');
    } else if (contactnumber!.isEmpty) {
      setState(() => name = 'At Least 1 Person or Message Required');
    } else {}
  }
}
