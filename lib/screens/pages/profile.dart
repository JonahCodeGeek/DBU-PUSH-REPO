import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/providers/get_current_user.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:dbu_push/widgets/build_text_field.dart';
import 'package:dbu_push/widgets/buttons.dart';
import 'package:dbu_push/widgets/progress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dbu_push/widgets/circle_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

UserModel? currentUser;

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.profileId}) : super(key: key);
  final String? profileId;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? currentUserId;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? file;
  bool isFile = false;
  String avatorId = Uuid().v4();
  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<GetCurrentUser>(context,listen: false).currentUser;
    setState(() {
      currentUserId = currentUser?.id;
    });
  }

  takePhoto(ImageSource source) async {
    Navigator.pop(context);
    XFile? file =
        await _picker.pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = File(file!.path);
    });
  }

  Future<String> uploadImage(File imagefile) async {
    UploadTask uploadTask =
        storage.child('profile_$avatorId.jpg').putFile(imagefile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

  handleUpdate() async {
    String imageUrl = await uploadImage(file!);
    usersDoc.doc(currentUserId).update({
      'fullName': nameController.text,
      'bio': bioController.text,
      'avatar': imageUrl
    });
    setState(() {
      file = null;
      avatorId = Uuid().v4();
    });
  }

  handleLogout() {
    //
  }

  buildProfile() {
    bool isProfileOwner = widget.profileId == currentUserId;
    return FutureBuilder<DocumentSnapshot>(
      future: usersDoc.doc(widget.profileId).get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        UserModel user = UserModel.fromDocument(snapshot.data!);
        nameController.text = user.fullName!;
        bioController.text = user.bio!;
        idController.text = user.uId!;
        phoneController.text = user.phone!;
        emailController.text = user.email!;
        if (isProfileOwner) {
          isFile = file != null;
          return Padding(
            padding: EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey,
                      child: isFile
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(file!.path),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        CachedNetworkImageProvider(user.avatar),
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        child: buildIconButton(AppColors.primaryColor),
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return buildBottomSheet(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                buildEditInfo(),
                buildProfileBody(handleUpdate, handleLogout)
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 60),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.avatar),
                ),
                buildUserInfo(user),
              ],
            ),
          );
        }
      }),
    );
  }

  Container buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            'Change Your Profile Photo',
            style: TextStyle(
                color: AppColors.textColor3,
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => takePhoto(ImageSource.camera),
                icon: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                onPressed: () => takePhoto(ImageSource.gallery),
                icon: Icon(
                  Icons.photo,
                  size: 35,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel,
                  size: 35,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildUserInfo(UserModel user) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16),
      child: Column(
        children: [
          BuildTextField(
            readOnly: false,
            nameController: nameController,
            textName: 'FullName',
            giveHintText: '',
          ),
          BuildTextField(
            readOnly: false,
            nameController: emailController,
            textName: 'Email',
            giveHintText: '',
          ),
          BuildTextField(
              nameController: phoneController,
              textName: 'Phone',
              giveHintText: '',
              readOnly: false),
          BuildTextField(
            readOnly: false,
            nameController: bioController,
            textName: 'Bio',
            giveHintText: '',
          ),
          BuildTextField(
            readOnly: false,
            nameController: idController,
            textName: 'Id',
            giveHintText: '',
          ),
        ],
      ),
    );
  }

  Widget buildEditInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16),
      child: Column(
        children: [
          BuildTextField(
            readOnly: true,
            nameController: nameController,
            textName: 'FullName',
            giveHintText: 'update your name',
          ),
          BuildTextField(
            readOnly: true,
            nameController: bioController,
            textName: 'Bio',
            giveHintText: 'update Your bio',
          ),
          BuildTextField(
            readOnly: true,
            nameController: idController,
            textName: 'Id',
            giveHintText: 'update Your Id',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        buildProfile(),
      ],
    ));
  }
}
