// ignore_for_file: unused_import, unused_field

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dbu_push/screens/pages/public_channel_detail.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import '../../widgets/app_button.dart';
import '../../widgets/progress.dart';

class CreateChannels extends StatefulWidget {
  const CreateChannels({Key? key}) : super(key: key);

  @override
  State<CreateChannels> createState() => _CreateChannelsState();
}

class _CreateChannelsState extends State<CreateChannels> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final _channels = FirebaseFirestore.instance.collection('channels');
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _channelNameController = TextEditingController();
  final _channelUserNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _channelKeyController = TextEditingController();
  String avatar = '';
  String docId = '';
  String backgroundImg = '';
  File? _profileImage, _backImage;
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  String profileId = Uuid().v4();
  final List members = [];

  bool withChannelType() {
    if (status1 == true || status2 == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadBackImg(File imageFile) async {
    UploadTask uploadTask = storage
        .ref('/channel/background image/$profileId.jpg')
        .putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadProfile(File imageFile) async {
    UploadTask uploadTask =
        storage.ref('/channel/profile image/$profileId.jpg').putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> createChannel() async {
    if (withChannelType()) {
      if (_channelNameController.text != '' ||
          _channelUserNameController.text != '' ||
          _channelKeyController.text != '' ||
          _bioController.text != '') {
        String imageUrl =
            _backImage == null ? '' : await uploadBackImg(_backImage!);
        String profileImage = await uploadProfile(_profileImage!);
        return _channels.add({
          'creator': _userId,
          'name': _channelNameController.text.trim(),
          'username': '@${_channelUserNameController.text.trim()}',
          'type': status1 == true ? 'private' : 'public',
          'members': [],
          'key': _channelKeyController.text.trim(),
          'bio': _bioController.text.trim(),
          'backgroundImage':
              backgroundImg == '' ? '' : imageUrl, //URL for IMAGE
          'avatar': avatar == '' ? '' : profileImage,
          'created': formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' '])
              .toString(), //URL for IMAGE
        }).then((value) {
          // Navigator.of(context).pop();
          setState(() {
            docId = value.id;
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => PublicDetail(docId: docId)),
            ),
          );
          print(docId);
          return showSnackBar(
              context, 'Channel created successfully', Colors.green);
        });
      }
      return showSnackBar(context, 'Please insert every data', Colors.red);
    } else {
      return showSnackBar(
          context, 'Please you must choose a channel type!', Colors.red);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _channelUserNameController.dispose();
    _channelKeyController.dispose();
    _channelNameController.dispose();
    _bioController.dispose();
  }

  profile(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      _profileImage = File(image!.path);
      avatar = _profileImage!.path;
      print(_profileImage!.path);
    });
  }

  backImage(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      _backImage = File(image!.path);
      backgroundImg = _backImage!.path;
      print(_backImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        backImage(ImageSource.gallery);
                      },
                      child: _backImage == null
                          ? Container(
                              width: double.maxFinite,
                              height: 250,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Container(
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
                    GestureDetector(
                      onTap: () {
                        backImage(ImageSource.gallery);
                      },
                      child: _backImage == null
                          ? Visibility(
                              visible: true,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
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
                                      'Add background image',
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.scaffoldColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Visibility(
                              visible: false,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
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
                                      'Add background image',
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.scaffoldColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        profile(ImageSource.gallery);
                      },
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          VerticalSpacer(200),
                          CircleAvatar(
                            backgroundColor: AppColors.scaffoldColor,
                            radius: 45,
                            child: _profileImage == null
                                ? Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.person_add,
                                      size: 40,
                                      color: AppColors.primaryColor,
                                    ),
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 58.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _channelNameController,
                  decoration: InputDecoration(
                    label: Text(
                      'Channel name',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              VerticalSpacer(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 58.0),
                child: TextFormField(
                  controller: _channelUserNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(
                      'Chanel username',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              VerticalSpacer(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 58.0),
                child: TextFormField(
                  controller: _bioController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(
                      'Bio/description',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              VerticalSpacer(10),
              Visibility(
                visible: status1 ? true : false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 58.0),
                  child: TextFormField(
                    controller: _channelKeyController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text(
                        'Channel key',
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              VerticalSpacer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlutterSwitch(
                      width: 30.0,
                      height: 30.0,
                      toggleSize: 30.0,
                      value: status1,
                      borderRadius: 30.0,
                      activeColor: AppColors.primaryColor,
                      onToggle: (val) {
                        setState(() {
                          status1 = val;
                          status2 = false;
                        });
                      }),
                  FlutterSwitch(
                      width: 30.0,
                      height: 30.0,
                      toggleSize: 30.0,
                      value: status2,
                      borderRadius: 30.0,
                      activeColor: AppColors.primaryColor,
                      onToggle: (val) {
                        setState(() {
                          status2 = val;
                          status1 = false;
                        });
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // ignore: prefer_const_literals_to_create_immutables
                children: [Text('Private'), Text('Public')],
              ),
              VerticalSpacer(30),
              AppButton(
                onPressed: () {
                  createChannel();
                },
                text: 'Create channel',
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
          ),
        ),
      ),
    );
  }
}
