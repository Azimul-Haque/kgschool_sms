import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kgschool_sms/addcontact.dart';
import 'package:kgschool_sms/contacts.dart';
import 'package:kgschool_sms/globals.dart';
import 'package:kgschool_sms/models/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:excel_to_json/excel_to_json.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // final String title; required this.title

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late ContactModel newContact;
  final ContactHelper _contactHelper = ContactHelper();
  final TextEditingController _controllerMessage = TextEditingController();
  List<ContactModel> contacts = [];
  List<String> recipients = [];
  int _counter = 0;
  bool showloading = false;
  late String parseddata = '';
  late String message;
  int dropdownvalue = 0;

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
      contacts = newcontacts.toList();
      for (var item in contacts) {
        recipients.add(item.contactnumber);
      }
    });
  }

  void _sendSMS() async {
    // List<String> recipients = ["01837409842", "01751398392", "01744834258"];
    setState(() {
      showloading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    List temprecipients = [];
    if (dropdownvalue == 220) {
      for (var i = 0; i < 220; i++) {
        temprecipients.add(recipients[i]);
      }
    } else if (dropdownvalue == 221) {
      for (var i = 220; i < recipients.length; i++) {
        temprecipients.add(recipients[i]);
      }
    }
    print(temprecipients.length);
    print(temprecipients.toString());
    print(dropdownvalue);
    print(message);
    _counter = 0;

    // showLoadingDialog(context);

    for (var i = 0; i < temprecipients.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      // String _result = await sendSMS(
      //         message: message, recipients: [recipients[i]], sendDirect: true)
      //     .catchError((onError) {
      //   print(onError);
      // });
      // if (_result == "SMS Sent!") {
      //   setState(() {
      //     _counter++;
      //   });
      // }
      // print(_result);

      // TEST
      setState(() {
        _counter++;
      });
      if (temprecipients.length == _counter) {
        showSimpleSnackBar(
            context, _counter.toString() + ' টি নাম্বারে মেসেজ পাঠানো হয়েছে!');
        setState(() {
          showloading = false;
        });
      }
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
              ExcelToJson().convert().then((onValue) {
                // print(jsonEncode(onValue).length);
                setState(() {
                  parseddata = onValue!;
                  // parseddata = onValue.split(",");
                  List decodeddata = jsonDecode(onValue);
                  // print('${decodeddata.runtimeType} : $decodeddata');
                  print(decodeddata.length);
                  if (decodeddata.length > 200) {
                    _contactHelper.deleteContactTable();
                  }
                  var totalpassed = 0;
                  for (var item in decodeddata) {
                    // print(item['contact_Numbers']);
                    newContact = ContactModel(
                      id: 1,
                      name: 'KG School ' + item['contact_Numbers'],
                      contactnumber: item['contact_Numbers'],
                    );
                    _contactHelper.insertContact(newContact);
                    totalpassed++;
                  }
                  _loadContacts();
                  showSimpleSnackBar(context,
                      totalpassed.toString() + ' টি নম্বর যোগ করা হয়েছে!');
                });
              });
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
                MaterialPageRoute(builder: (context) => const ContactsList(refresh),
              );
            },
            icon: const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'মোট নাম্বারঃ ',
                  ),
                  Text(
                    recipients.length.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const Divider(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: 'কতগুলো মেসেজ পাঠাতে চান?',
                          hint: const Text('কতগুলো মেসেজ পাঠাতে চান?'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          isExpanded: true,
                          items: <String>[
                            'কতগুলো মেসেজ পাঠাতে চান?',
                            'প্রথম ২২০ টি নম্বরে',
                            '২২১ নম্বর থেকে পরবর্তী সকল নম্বরে'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == 'কতগুলো মেসেজ পাঠাতে চান?') {
                              return 'Required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value == 'প্রথম ২২০ টি নম্বরে') {
                              setState(() {
                                dropdownvalue = 220;
                              });
                            } else if (value ==
                                '২২১ নম্বর থেকে পরবর্তী সকল নম্বরে') {
                              setState(() {
                                dropdownvalue = 221;
                              });
                            }
                            print(value);
                          },
                        ),
                        const Divider(),
                        TextFormField(
                          controller: _controllerMessage,
                          maxLength: 98,
                          toolbarOptions: const ToolbarOptions(
                              copy: true,
                              paste: true,
                              cut: true,
                              selectAll: true),
                          minLines: 3,
                          maxLines: 4,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.sms),
                            hintText: 'টেক্সট মেসেজ লিখুন',
                            labelText: 'মেসেজ',
                          ),
                          onChanged: (String value) {
                            setState(() {
                              message = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const Divider(),
                        SizedBox(
                          width: 400,
                          child: showloading == false
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _sendSMS();
                                      _formKey.currentState!.reset();
                                    }
                                  },
                                  child: const Text('মেসেজ পাঠান'),
                                )
                              : Container(),
                        ),
                        const Divider(),
                        showloading == true
                            ? const CircularProgressIndicator()
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        showloading == true
                            ? Text(_counter.toString() +
                                ' টি নাম্বারে পাঠানো হয়েছে।')
                            : Container(),
                      ],
                    ),
                  ),
                  // Text(parseddata),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendSMS,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  refresh() {
    _loadContacts();
  }
}
