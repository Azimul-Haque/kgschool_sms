import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kgschool_sms/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late ContactHelper _contactHelper;
  List<ContactModel> contacts = [];
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _loadDB();
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
          title: const Text('Contact List'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Contact Name'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  _loadDB() async {
    await Future.delayed(const Duration(seconds: 1)); // THIS LITLE LINE!!!
    var newquestions = await _contactHelper.getAllContacts();
    setState(() {
      contacts = newquestions.reversed.toList();
      isLoading = false;
    });
    if (questions.length == 0) {
      _getSynced(questions.length);
    }
  }
}
