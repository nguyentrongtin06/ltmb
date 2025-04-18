import 'package:flutter/material.dart';
import 'package:app_1/BaiTapNote/model/note.dart';
import 'package:app_1/BaiTapNote/view/note_form.dart';

class NoteEditScreen extends StatelessWidget {
  final Note note;

  NoteEditScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Note')),
      body: NoteForm(note: note, isEditMode: true),
    );
  }
}