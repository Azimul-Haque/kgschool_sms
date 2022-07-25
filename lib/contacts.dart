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
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              contacts.isNotEmpty
                  ? ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                        child: ListTile(
                          // leading: CircleAvatar(child: Text(questions[index].question[0]),),
                          title: Text(questions[index].question),
                          subtitle: Text('- ' + questions[index].answer),
                          trailing: listPopUpMenu(questions[index]),
                          // onTap: (){
                          //   // Route route = MaterialPageRoute(builder: (context) => PageTwo(questions[index]));
                          //   // Navigator.push(context, route);
                          //   // _showSnackbar("তথ্য হালনাগাদ হয়েছে!");
                          // },
                        ),
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
                              : const Text("কোন নতুন নাম্বার নেই!"),
                        ],
                      ),
                    ),
            ],
          ),
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
  }
}
