import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:note101_app/component/alert.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final docID;
  final note;
   EditNote({super.key, this.docID, this.note});

  @override
  // ignore: library_private_types_in_public_api
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  var ref;
  var file;
  var noteTitle, note, imageURL;
  CollectionReference noteRef = FirebaseFirestore.instance.collection('notes');

  editNote(context) async {
    var formData = formState.currentState;
    if (file == null) {
      if (formData != null) {
        if (formData.validate()) {
          showLoading(context);

          formData.save();
          await noteRef.doc(widget.docID).update({
            'noteTitle': noteTitle,
            'note': note,
          }).then((value) {
            Navigator.of(context).pushReplacementNamed('homePage');
          }).catchError((e){
            print('$e');
          });
        }
      }
    }else{
      if (formData != null) {
        if (formData.validate()) {
          showLoading(context);

          formData.save();

          await ref.putFile(file);
          imageURL = await ref.getDownloadURL();

          await noteRef.doc(widget.docID).update({
            'noteTitle': noteTitle,
            'note': note,
            'imageUrl': imageURL,
          }).then((value) {
            Navigator.of(context).pushReplacementNamed('homePage');
          }).catchError((e){
            print('$e');
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        child: Form(
          key: formState,
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {
                  showTheBottomSheet(context);
                },
                color: Colors.grey,
                shape: const CircleBorder(),
                textColor: Colors.white,
                padding: const EdgeInsets.all(25),
                child: const Icon(
                  Icons.add_a_photo,
                  size: 35,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                validator: (val) {
                  if (val != null) {
                    if (val.length < 2) {
                      return ('The title note must be more than two letters');
                    }
                  }
                },
                initialValue: widget.note['noteTitle'],
                onSaved: (val) {
                  noteTitle = val;
                },
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  prefixIcon: Icon(Icons.title),
                  label: Text('Note Title'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                validator: (val) {
                  if (val != null) {
                    if (val.length < 5) {
                      return ('The note must be more than 6 letters');
                    } else {
                      return null;
                    }
                  }
                },
                initialValue: widget.note['note'],
                onSaved: (val) {
                  note = val;
                },
                minLines: 2,
                maxLines: 4,
                maxLength: 150,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  label: Text('Note'),
                  prefixIcon: Icon(Icons.article),
                  filled: true,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  await editNote(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    'Edit Note',
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showTheBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (index) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            child: Column(
              children: [
                const Text(
                  'Please Choose Note Image',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_a_photo),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () async {
                          var picked = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (picked != null) {
                            file = File(picked.path);
                            var rand = Random().nextInt(10000);
                            var imageName = "$rand" + basename(picked.path);
                            ref = FirebaseStorage.instance
                                .ref('images')
                                .child(imageName);

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('From Camera'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.category),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () async {
                          var picked = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (picked != null) {
                            file = File(picked.path);
                            var rand = Random().nextInt(10000);
                            var imageName = '$rand' + picked.path;
                            ref = FirebaseStorage.instance
                                .ref('images')
                                .child(imageName);

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('From Gallery'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
