

import 'package:flutter/material.dart';

showLoading(context){
  return showDialog(context: context, builder: (context){
    return const AlertDialog(
      title:  Text('Please wait'),
      content:  SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  });
}