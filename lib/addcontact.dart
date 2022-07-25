import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
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
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: TextField(
                controller: _controllerName,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                onChanged: (String value) => setState(() {}),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: TextField(
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                controller: _controllerContactNumber,
                keyboardType: TextInputType.number,
                onChanged: (String value) => setState(() {}),
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
            Visibility(
              visible: name != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        name ?? 'No Data',
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
