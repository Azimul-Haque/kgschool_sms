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
              barmodeltests.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: barmodeltests.length,
                      itemBuilder: (context, index) {
                        return _scrollCard(
                            barmodeltests[index]["name"].toString(),
                            barmodeltests[index]["exam_id"].toString(),
                            screenwidth);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          _showCircle == true
                              ? CircularProgressIndicator()
                              : Text("কোন নতুন পরীক্ষা নেই!"),
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
