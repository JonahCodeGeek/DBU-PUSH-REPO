// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_import, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../utils/helpers/custom_functions.dart.dart';
import '../../widgets/app_button.dart';
import 'public_channel_detail.dart';

class EditChannel extends StatefulWidget {
  final String docId;
  EditChannel({Key? key, required this.docId}) : super(key: key);

  @override
  State<EditChannel> createState() => _EditChannelState();
}

class _EditChannelState extends State<EditChannel> {
  final _channelNameController = TextEditingController();
  final _channelUserNameController = TextEditingController();
  final _bioController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String avatar = '';
  String docId = '';
  String backgroundImg = '';
  File? _profileImage, _backImage;
  String profileId = Uuid().v4();
  String previousName = '';
  String previousUserName = '';
  String previousBio = '';
  String previousProfile = '';
  String previousBackground = '';
  final CollectionReference channelDocument =
      FirebaseFirestore.instance.collection('channels');
  final database = FirebaseFirestore.instance.collection('channels');
  List channel = [];

//upload back image to firebase storage
  Future<String> uploadBackImg(File imageFile) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref('/channel/background image/$profileId.jpg')
        .putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }
  //upload profile image to firebase storage

  Future<String> uploadProfile(File imageFile) async {
    firebase_storage.UploadTask uploadTask =
        storage.ref('/channel/profile image/$profileId.jpg').putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

//profile image selector
  profile(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      _profileImage = File(image!.path);
      avatar = _profileImage!.path;
    });
  }

//backImage selector
  backImage(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      _backImage = File(image!.path);
      backgroundImg = _backImage!.path;
    });
  }

  getResult() async {
    await database.doc(widget.docId).get().asStream().forEach((element) {
      setState(() {
        return channel.add(element);
      });
    });
  }

  Future<bool> dataIsValid() async {
    final query1 = channelDocument.where('username',
        isEqualTo: _channelUserNameController.text.trim());
    final result = await query1.get();
    final userNameExists = result.docs;

    if (userNameExists.isNotEmpty) {
      showSnackBar(context, 'username already exists', Colors.red);
      return false;
    }
    return true;
  }

  Future<void> updateInformation() async {
    setState(() {
      previousName = channel[0]['name'].toString();
      previousUserName = channel[0]['username'].toString();
      previousBio = channel[0]['bio'];
      previousProfile = channel[0]['avatar'];
      previousBackground = channel[0]['backgroundImage'];
    });
    String imageUrl = _backImage == null
        ? channel[0]['backgroundImage']
        : await uploadBackImg(_backImage!);
    String profileImage = _profileImage == null
        ? channel[0]['avatar']
        : await uploadProfile(_profileImage!);
    final query1 = channelDocument.where('username',
        isEqualTo: _channelUserNameController.text.trim());
    final result = await query1.get();
    final userNameExists = result.docs;
    if (userNameExists.isEmpty) {}

    await database.doc(widget.docId).update({
      'name': _channelNameController.text.trim() == ''
          ? channel[0]['name']
          : _channelNameController.text.trim(),
      'username': _channelUserNameController.text.trim() == ''
          ? channel[0]['username']
          : '@${_channelUserNameController.text.trim()}',
      'bio': _bioController.text.trim() == ''
          ? channel[0]['bio']
          : _bioController.text.trim(),
      'backgroundImage': backgroundImg == ''
          ? channel[0]['backgroundImage']
          : imageUrl, //URL for IMAGE
      'avatar': avatar == '' ? channel[0]['avatar'] : profileImage,
    }).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => PublicDetail(docId: widget.docId)),
        ),
      );
      return showSnackBar(
          context, 'information updated successfully', Colors.green);
    });
  }

  @override
  initState() {
    super.initState();
    getResult();
  }

  @override
  void dispose() {
    super.dispose();
    _channelUserNameController.dispose();
    _bioController.dispose();
    _channelNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: ListView.builder(
            itemCount: channel.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          backImage(ImageSource.gallery);
                        },
                        child: _backImage == null
                            ? Container(
                                width: double.maxFinite,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        channel[index]['backgroundImage']),
                                  ),
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )
                            : Container(
                                width: double.maxFinite,
                                height: 200,
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
                      Column(
                        children: [
                          VerticalSpacer(160),
                          Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    profile(ImageSource.gallery);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 45,
                                    child: _profileImage == null
                                        ? Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      channel[index]['avatar']),
                                                ),
                                                shape: BoxShape.circle),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                  File(_profileImage!.path),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //channel information
                        ],
                      ),
                    ],
                  ),
                  // Edit filed.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 58.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _channelNameController,
                      decoration: InputDecoration(
                          hintText: 'Channel name: ' + channel[index]['name']),
                    ),
                  ),
                  VerticalSpacer(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 58.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _channelUserNameController,
                      decoration: InputDecoration(
                        prefixStyle: TextStyle(color: AppColors.textColor1),
                        hintText: 'userName: ' + channel[index]['username'],
                      ),
                    ),
                  ),
                  VerticalSpacer(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 58.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()),
                      child: TextFormField(
                        maxLines: 100,
                        textInputAction: TextInputAction.newline,
                        controller: _bioController,
                        keyboardType: TextInputType.multiline,
                        maxLength: 150,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Bio: ' + channel[index]['bio']),
                      ),
                    ),
                  ),

                  VerticalSpacer(30),
                  AppButton(
                    onPressed: () {
                      updateInformation();
                    },
                    text: 'Update information',
                    width: 200,
                    height: 50,
                    buttonColor: AppColors.primaryColor,
                    fontColor: AppColors.scaffoldColor,
                    fontSize: 20,
                    buttonShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
