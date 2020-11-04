import 'package:flutter/material.dart';
import 'package:estudy/models/Book.dart';

class BookCardMinimalistic extends StatelessWidget {
  BookCardMinimalistic(this.book);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.network(book.url),
        ],
      ),
    );
  }
}
