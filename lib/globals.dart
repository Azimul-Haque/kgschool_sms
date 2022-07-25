import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

late Database? db;

showSimpleSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ),
  );
}
