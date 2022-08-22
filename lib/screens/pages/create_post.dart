// ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_import, non_constant_identifier_names, use_build_context_synchronously

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/helpers/custom_functions.dart.dart';
import 'public_channel_detail.dart';

class CreatePost extends StatefulWidget {
  final String docId;
  CreatePost({Key? key, required this.docId}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String post_id = '';
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference channels =
      FirebaseFirestore.instance.collection('channels');
  final _messageController = TextEditingController();
  final List postId = [];
  bool isVisible = false;
  bool isPrivate = false;
  final List channel = [];

  // ignore: unused_field

  final String _author = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createPost() async {
    if (_messageController.text.trim() == '') {
      return showSnackBar(
          context,
          'You must add either a message or a file to be posted!! ',
          Colors.red);
    }
    try {
      return await posts.add({
        'author': _author.toString(),
        'channel': widget.docId,
        'message': _messageController.text.trim(),
        'dislike': [],
        'like': [],
        'comment': [],
        'media_url': '',
        'created_at': formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
            .toString(),
        'updated_at': formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
            .toString(),
      }).then((value) {
        setState(() {
          postId.add(value.id);
        });
      }).then((value) async {
        await channels.doc(widget.docId).update(
          {
            'posts': FieldValue.arrayUnion(postId),
          },
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => PublicDetail(docId: widget.docId)),
          ),
        );
        return showSnackBar(
            context, 'Message posted successfully!!', Colors.green);
      });
    } catch (e) {
      return showSnackBar(context, e.toString(), Colors.red);
    }
  }

  getResult() async {
    await channels.doc(widget.docId).get().asStream().forEach((element) {
      // print(widget.docId);

      setState(() {
        return channel.add(element);
      });
      Future.delayed(Duration(seconds: 2), () {
        if (channel[0]['type' == 'private']) {
          setState(() {
            isPrivate = true;
          });
        } else {
          setState(() {
            isPrivate = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: AppColors.textColor1,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Visibility(
                  visible: isPrivate,
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  createPost();
                },
                child: Icon(
                  Icons.send,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, right: 10),
                child: TextFormField(
                  controller: _messageController,
                  autofocus: true,
                  cursorHeight: 22,
                  maxLines: 20,
                  minLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Write something  ',
                    hintStyle: GoogleFonts.roboto(
                        fontSize: 17, fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: Padding(
                  padding: EdgeInsets.only(left: 70.0),
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
