import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:kgschool_sms/models/contact_model.dart';
import 'package:kgschool_sms/updatecontact.dart';
// import 'package:sqflite/sqflite.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactHelper _contactHelper = ContactHelper();
  List<ContactModel> contacts = [];
  List<ContactModel> adhoccontacts = [];
  late bool isLoading;

  Widget appBarTitle = const Text('Contact List');
  Icon actionIcon = const Icon(Icons.search);
  final TextEditingController _controllerSearch = TextEditingController();
  bool search = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _loadContacts();
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
            title: appBarTitle,
            actions: <Widget>[
              IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (actionIcon.icon == Icons.search) {
                      actionIcon = const Icon(Icons.close);
                      appBarTitle = TextField(
                        showCursor: true,
                        cursorColor: Colors.white,
                        autofocus: true,
                        controller: _controllerSearch,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          // prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: " Search...",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onChanged: (value) {
                          // print('First text field: $value');
                          searchContact(value);
                        },
                      );
                    } else {
                      actionIcon = const Icon(Icons.search);
                      appBarTitle = const Text('Contact List');
                      _controllerSearch.text = '';
                      _loadContacts();
                    }
                  });
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: ListTile(
                  title:
                      Text('মোট নাম্বারঃ ' + adhoccontacts.length.toString()),
                ),
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              ),
              adhoccontacts.isNotEmpty
                  ? ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: adhoccontacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text((index + 1).toString() +
                                ". " +
                                adhoccontacts[index].name),
                            subtitle: Text(adhoccontacts[index].contactnumber),
                            trailing: Wrap(
                              spacing: 0,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateContact(
                                              adhoccontacts[index].id,
                                              adhoccontacts[index].name,
                                              adhoccontacts[index]
                                                  .contactnumber,
                                              refresh)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDeleteDialog(
                                        context, adhoccontacts[index].id);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                ),
                              ],
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 15, right: 0),
                          ),
                          margin: const EdgeInsets.only(right: 0, bottom: 5),
                          elevation: 2,
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text("কোন নাম্বার পাওয়া যায়নি!"),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _loadContacts() async {
    await Future.delayed(const Duration(seconds: 1)); // THIS LITLE LINE!!!
    var newcontacts = await _contactHelper.getAllContacts();
    setState(() {
      contacts = newcontacts.reversed.toList();
      adhoccontacts = newcontacts.reversed.toList();
      isLoading = false;
    });

    // print(contacts.length);
  }

  refresh() {
    _loadContacts();
  }

  searchContact(value) {
    List<ContactModel> searchContacts = [];
    for (var contact in contacts) {
      if (contact.name.toLowerCase().contains(value.toLowerCase()) ||
          contact.contactnumber
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
        searchContacts.add(contact);
      }
    }
    setState(() {
      adhoccontacts = [];
      adhoccontacts = searchContacts;
    });
    print(adhoccontacts.length);
  }

  Future<void> showDeleteDialog(BuildContext context, int contactid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text('আপনি কি নিশ্চিতভাবে ডিলেট করতে চান?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _contactHelper.deleteContact(contactid);
                showSimpleSnackBar(context, 'Deleted successfully');
                Navigator.of(context).pop();
                _loadContacts();
              },
            ),
          ],
        );
      },
    );
  }
}
