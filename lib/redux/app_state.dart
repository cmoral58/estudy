import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:estudy/data/repository.dart';
import 'package:estudy/models/Book.dart';

class AppState {
  AppState({this.readBooks});

  final List<Book> readBooks;

  static AppState initState() {
    return new AppState(readBooks: []);
  }
}
