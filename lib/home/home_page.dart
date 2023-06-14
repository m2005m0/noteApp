import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note101_app/edit_note/view_note.dart';

import '../edit_note/editNote.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.email);
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  CollectionReference noteRef = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('login');
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: FutureBuilder(
        future: noteRef
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder  (
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  return Dismissible  (
                      key: UniqueKey(),
                      onDismissed: (direction) async{
                        await noteRef.doc(snapshot.data?.docs[i].id).delete();
                        await FirebaseStorage.instance.refFromURL(snapshot.data.docs[i]['imageUrl']).delete();
                      },
                      child: NoteItem(
                        snapshot.data.docs[i].id,
                        snapshot.data.docs[i],
                      ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addNote');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final docID;
  final note;

  const NoteItem(this.docID, this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 110.0,
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return  ViewNote(note: note);
          }));
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  '${note['imageUrl']}',
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text('${note["noteTitle"]}'),
                  subtitle: Text(note['note']),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNote(
                              note: note,
                              docID: docID,
                            ),
                          ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  //trailing: ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
