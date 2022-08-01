import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/screens/pages/home.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:dbu_push/widgets/build_text_field.dart';
import 'package:dbu_push/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:dbu_push/widgets/circle_button.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.profileId}) : super(key: key);
  final String? profileId;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUserId = currentUser?.id;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isProfileOwner = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isProfileOwner = false;
    });
  }

  buildProfile() {
    // isProfileOwner = widget.profileId == currentUserId;
    return FutureBuilder<DocumentSnapshot>(
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data!);
        nameController.text = user.fullName!;
        bioController.text = user.bio!;
        idController.text = user.uId!;
        phoneController.text = user.phone!;
        emailController.text = user.email!;
        if (isProfileOwner) {
          return Padding(
            padding: EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.avatar ?? '')),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        child: buildIconButton(AppColors.primaryColor),
                        onTap: () => print('change your photo'),
                      ),
                    ),
                  ],
                ),
                buildEditInfo(),
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
                  backgroundImage:
                      CachedNetworkImageProvider(user.avatar ?? ''),
                ),
                buildUserInfo(user),
              ],
            ),
          );
        }
      }),
      future: usersDoc.doc('O6DlpswReyWvbFnjUbHA').get(),
    );
  }

  Padding buildUserInfo(User user) {
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
            readOnly:false,
            nameController: emailController,
            textName: 'Email',
            giveHintText: '',
          ),
          BuildTextField(
            nameController: phoneController,
            textName: 'Phone',
            giveHintText: '', readOnly: false
          ),
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
      body: buildProfile()
    );
  }
}

