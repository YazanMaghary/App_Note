import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class showNotes extends StatefulWidget {
  final docid ;
  final list ; 
  const showNotes({super.key,this.docid,this.list});

  @override
  State<showNotes> createState() => _showNotesState();
}

class _showNotesState extends State<showNotes> {
  var firestore = FirebaseFirestore.instance.collection("Notes");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.list["Note title "]}"),centerTitle: true,backgroundColor: Theme.of(context).primaryColor,),
      body: Container(
        child: Column(
          children: [
           Expanded(child:  Container(width: double.infinity,height: 400,padding: EdgeInsets.all(10),
              child: Image(image: NetworkImage(widget.list["Image Url"]),fit: BoxFit.cover,),
            ))
            ,
            Expanded(child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.all(10),
              child: Text(widget.list["Note"],style: TextStyle(
                fontSize: 20
              ),),
            ))
          ],
        ),
      ),
    );
  }
}