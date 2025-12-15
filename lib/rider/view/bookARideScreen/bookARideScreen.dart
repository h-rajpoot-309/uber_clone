import 'package:flutter/material.dart';

class BookARideScreen extends StatefulWidget {
  const BookARideScreen({super.key});

  @override
  State<BookARideScreen> createState() => _BookARideScreenState();
}

class _BookARideScreenState extends State<BookARideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Book a ride screen')));
  }
}
