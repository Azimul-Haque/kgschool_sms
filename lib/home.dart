import 'dart:convert';

import 'dart:math';
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
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controllerMessage = TextEditingController();
  final TextEditingController _controllerCaptcha = TextEditingController();
  List<ContactModel> contacts = [];
  List<String> recipients = [];
  int _counter = 0;
  bool showloading = false;
  late String parseddata = '';
  late String message;
  late int captchanumber;
  int dropdownvalue = 0;
  final int randomNumber1 = Random().nextInt(10);
  final int randomNumber2 = Random().nextInt(10);
  late int randomSum = randomNumber1 + randomNumber2;
  late String hint = randomNumber1.toString() +
      ' + ' +
      randomNumber2.toString() +
      ' = ? (ইংরেজিতে লিখুন)';

  @override
  void initState() {
    super.initState();
    promptSMS();
    _loadContacts();
    setState(() {});
    // print(randomNumber1);
    // print(randomNumber2);
    // print(randomSum);
  }

  void promptSMS() async {
    await Permission.sms.request();
  }

  _loadContacts() async {
    await Future.delayed(const Duration(seconds: 1)); // THIS LITLE LINE!!!
    var newcontacts = await _contactHelper.getAllContacts();
    recipients = [];
    setState(() {
      contacts = newcontacts.toList();
      for (var item in contacts) {
        recipients.add(item.contactnumber);
      }
    });
  }

  void _sendSMS() async {
    // List<String> recipients = ["01837409842", "01751398392", "01744834258"];
    // print(recipients);
    setState(() {
      showloading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    List temprecipients = [];
    if (recipients.length > 220) {
      if (dropdownvalue == 220) {
        for (var i = 0; i < 220; i++) {
          temprecipients.add(recipients[i]);
        }
      } else if (dropdownvalue == 221) {
        for (var i = 220; i < recipients.length; i++) {
          temprecipients.add(recipients[i]);
        }
      }
    } else {
      for (var i = 0; i < recipients.length; i++) {
        temprecipients.add(recipients[i]);
      }
    }
    // print(temprecipients.length);
    // print(temprecipients.toString());
    // print(dropdownvalue);
    // print(message);
    _counter = 0;

    // showLoadingDialog(context);

    for (var i = 0; i < temprecipients.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      String _result = await sendSMS(
              message: message,
              recipients: [temprecipients[i]],
              sendDirect: true)
          .catchError((onError) {
        // print(onError);
      });
      if (_result == "SMS Sent!") {
        setState(() {
          _counter++;
        });
      }
      print(_result);

      // TEST
      // setState(() {
      //   _counter++;
      // });
      if (temprecipients.length == _counter) {
        showSimpleSnackBar(
            context, _counter.toString() + ' টি নাম্বারে মেসেজ পাঠানো হয়েছে!');
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          showloading = false;
        });
      }
      _controllerMessage.text = '';
      _controllerCaptcha.text = '';
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
      bottomSheet: const SizedBox(
        height: 25,
        width: double.infinity,
        child: Text(
          'Developed by A. H. M. Azimul Haque',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),

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
                MaterialPageRoute(builder: (context) => AddContact(refresh)),
              );
            },
            icon: const Icon(CupertinoIcons.person_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsList(refresh)),
              );
            },
            icon: const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'মোট নাম্বারঃ ' + recipients.length.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
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
                          copy: true, paste: true, cut: true, selectAll: true),
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
                          return 'মেসেজ লিখুন!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _focusNode,
                      controller: _controllerCaptcha,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.calculate),
                        hintText: hint,
                        labelText: hint,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          captchanumber = value as int;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'যোগফল লিখুন!';
                        } else if (value != randomSum.toString()) {
                          return 'যোগফল সঠিক লিখুন!';
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
                        ? Text(
                            _counter.toString() + ' টি নাম্বারে পাঠানো হয়েছে।')
                        : Container(),
                  ],
                ),
              ),
              // Text(parseddata),
            ],
          ),
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
