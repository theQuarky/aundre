import 'package:flutter/material.dart';

class FullNoteView extends StatefulWidget {
  const FullNoteView({super.key});

  @override
  State<FullNoteView> createState() => _FullNoteViewState();
}

class _FullNoteViewState extends State<FullNoteView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Full Note View'),
      ),
    );
  }
}
