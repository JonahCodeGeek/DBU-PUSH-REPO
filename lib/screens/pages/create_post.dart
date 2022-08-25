// ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_import, non_constant_identifier_names, use_build_context_synchronously

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import 'public_channel_detail.dart';

class CreatePost extends StatefulWidget {
  final String docId;
  CreatePost({Key? key, required this.docId}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String backgroundImg = '';
  String profileId = Uuid().v4();

  String post_id = '';
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference channels =
      FirebaseFirestore.instance.collection('channels');
  final _messageController = TextEditingController();
  final List postId = [];
  bool isVisible = false;
  bool isPrivate = false;
  String channelImage = '';
  bool iconVisible = true;
  final List channel = [];
  File? _backImage;

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
      if (_backImage == null) {
        try {
          return await posts.add({
            'author': _author.toString(),
            'post_type': isPrivate ? 'private' : 'public',
            'channel_image': channelImage,
            'channel': widget.docId,
            'message': _messageController.text.trim(),
            'dislike': [],
            'like': [],
            'comment': [],
            'media_url': '',
            'created_at':
                formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
                    .toString(),
            'updated_at':
                formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
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
      } else {
        String imageUrl = await uploadBackImg(_backImage!);
        setState(() {
          backgroundImg = imageUrl;
        });
        return await posts.add({
          'author': _author.toString(),
          'post_type': isPrivate ? 'private' : 'public',
          'channel': widget.docId,
          'channel_image': channelImage,
          'message': _messageController.text.trim(),
          'dislike': [],
          'like': [],
          'comment': [],
          'media_url': backgroundImg == '' ? '' : imageUrl,
          'created_at':
              formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
                  .toString(),
          'updated_at':
              formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
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
      }
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
      Future.delayed(Duration(seconds: 0), () {
        if (channel[0]['type'] == 'public') {
          setState(() {
            channelImage = channel[0]['avatar'];
          });
        }
        if (channel[0]['type'] == 'private') {
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

  Future<String> uploadBackImg(File imageFile) async {
    UploadTask uploadTask = storage
        .ref('/channel/background image/$profileId.jpg')
        .putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

  backImage(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      _backImage = File(image!.path);
      backgroundImg = _backImage!.path;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  void initState() {
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
                  maxLines: 10,
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
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      _backImage == null
                          ? Container(
                              width: double.maxFinite,
                              height: 250,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                backImage(ImageSource.gallery);
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: 250,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(_backImage!.path),
                                    ),
                                  ),
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                      Visibility(
                        visible: backgroundImg == '' ? true : false,
                        child: GestureDetector(
                          onTap: () {
                            backImage(ImageSource.gallery);
                          },
                          child: Column(
                            children: [
                              VerticalSpacer(90),
                              Center(
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: AppColors.scaffoldColor,
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Add image to a post',
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.scaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
