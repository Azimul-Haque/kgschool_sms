// import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:kgschool_sms/globals.dart';
import 'package:kgschool_sms/models/contact_model.dart';

class UpdateContact extends StatefulWidget {
  final int id;
  final String name;
  final String contactnumber;
  const UpdateContact(this.id, this.name, this.contactnumber, {Key? key})
      : super(key: key);
  // const UpdateContact({Key? key}) : super(key: key);

  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerContactNumber =
      TextEditingController();
  late String name, contactnumber;
  late ContactModel newContact;
  final ContactHelper _contactHelper = ContactHelper();

  @override
  void initState() {
    super.initState();
    print(widget.name);
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
          title: const Text('Update Contact'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  // initialValue: widget.name,
                  controller: _controllerName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  keyboardType: TextInputType.text,
                  onChanged: (String value) => setState(() {
                    name = value;
                  }),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Name is empty';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone),
                title: TextFormField(
                  // initialValue: widget.contactnumber,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  controller: _controllerContactNumber,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  onChanged: (String value) => setState(() {
                    contactnumber = value;
                  }),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Mobile Number is empty';
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
                    if (_formKey.currentState!.validate()) {
                      _updateContact();
                    }
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

  void _updateContact() async {
    newContact = ContactModel(
      id: 1,
      name: name.toString(),
      contactnumber: contactnumber.toString(),
    );
    await _contactHelper.updateContact(newContact);
    showSimpleSnackBar(context, 'Updated successfully!');
    Navigator.pop(context);
  }
}
