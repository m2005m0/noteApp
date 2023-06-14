import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final note;

  const ViewNote({this.note, super.key});

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veiw Note'),
      ),
      body: Container(
        child: Column(
          children: [
            Image.network(
              '${widget.note?['imageUrl']}',
              fit: BoxFit.fill,
              width: double.infinity,
              height: 300.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '${widget.note['noteTitle']}',
                style: TextStyle(fontSize: 30, color: Colors.indigo),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '${widget.note['note']}',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
