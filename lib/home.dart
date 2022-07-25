import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kgschool_sms/addcontact.dart';
import 'package:kgschool_sms/contacts.dart';
import 'package:kgschool_sms/models/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // final String title; required this.title

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ContactHelper _contactHelper = ContactHelper();
  List<ContactModel> contacts = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    promptSMS();
    _loadContacts();
  }

  void promptSMS() async {
    await Permission.sms.request();
  }

  _loadContacts() async {
    await Future.delayed(const Duration(seconds: 1)); // THIS LITLE LINE!!!
    var newcontacts = await _contactHelper.getAllContacts();
    setState(() {
      contacts = newcontacts.reversed.toList();
    });
    for (var item in contacts) {
    recipients = }
  }

  void _sendSMS() async {
    String message = "This is a test message 654654!";
    List<String> recipients = ["01837409842", "01751398392", "01744834258"];

    for (var i = 0; i < recipients.length; i++) {
      String _result = await sendSMS(
              message: message, recipients: [recipients[i]], sendDirect: true)
          .catchError((onError) {
        print(onError);
      });
      if (_result == "SMS Sent!") {
        setState(() {
          _counter++;
        });
      }
      print(_result);
    }
  }
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.message),
        title: const Text('School SMS'),
        actions: [
          IconButton(
            onPressed: () {
              // UPLOAD XLXS
            },
            icon: const Icon(CupertinoIcons.cloud_upload_fill),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddContact()),
              );
            },
            icon: const Icon(CupertinoIcons.person_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactsList()),
              );
            },
            icon: const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'SMS sent:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendSMS,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
