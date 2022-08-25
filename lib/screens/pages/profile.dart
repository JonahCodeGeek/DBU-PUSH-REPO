import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/providers/get_current_user.dart';
import 'package:dbu_push/screens/pages/page_navigator.dart';
import 'package:dbu_push/services/auth_methods.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:dbu_push/widgets/build_text_field.dart';
import 'package:dbu_push/widgets/buttons.dart';
import 'package:dbu_push/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dbu_push/widgets/circle_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key, required this.profileId}) : super(key: key);
  final String? profileId;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? currentUserId;
  UserModel? user;
  AuthenticationService? service;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? file;
  bool isFile = false;
  String avatorId = Uuid().v4();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
    UserModel? currentUser =
        Provider.of<GetCurrentUser>(context, listen:false).currentUser;
    setState(() {
      currentUserId = currentUser?.id;
    });
  }

  bool validateName() {
    if (nameController.text.trim().length < 3 ||
        nameController.text.trim().length > 10) {
      return false;
    } else {
      return true;
    }
  }

  bool validatBio() {
    if (bioController.text.trim().length > 40) {
      return false;
    } else {
      return true;
    }
  }

  bool validateId() {
    if (idController.text.trim().length != 8) {
      return false;
    } else {
      return true;
    }
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    // DocumentSnapshot docs = await usersDoc.doc(widget.profileId).get();
    // final doc = usersDoc.where('id', isEqualTo: currentUserId).get();
    //  final docs=doc.then((snapshot) => {
    //       snapshot.docs.forEach((element) {
    //         UserModel? getUsers = UserModel.fromDocument(element);
    //         setState(() {
    //           user = getUsers;
    //         });
    //       })
    //     }
    //     );
    // UserModel? getUsers = UserModel.fromDocument(docs);
    final users = context.read<GetUsers>();
    users.getUser(user);
    setState(() {
      // UserModel? user = Provider.of<GetUsers>(context, listen: false).user;
      user = Provider.of<GetUsers>(context, listen: false).user;
    });
    nameController.text = user?.fullName ?? '';
    bioController.text = user?.bio ?? '';
    idController.text = user?.uId ?? '';
    phoneController.text = user?.phone ?? '';
    emailController.text = user?.email ?? '';
    setState(() {
      isLoading = false;
    });
  }

  takePhoto(ImageSource source) async {
    Navigator.pop(context);
    XFile? file =
        await _picker.pickImage(source: source, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = File(file?.path ?? '');
    });
  }

  Future<String?> uploadImage(imagefile) async {
    UploadTask uploadTask =
        storage.child('profile_$avatorId.jpg').putFile(imagefile);
    String? imageUrl = await (await uploadTask).ref.getDownloadURL();
    return imageUrl;
  }

  updateFromCamera() async {
    await takePhoto(ImageSource.camera);
    String? imageUrl = await uploadImage(file);
    usersDoc.where('id', isEqualTo: widget.profileId).get().then((snapshot) => {
          snapshot.docs.forEach((element) {
            usersDoc.doc(element.id).update({
              'avatar': imageUrl
            });
          })
        });
    // usersDoc.doc(widget.profileId).update({'avatar': imageUrl});
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => PageNavigator(authUser: user)),
        ));
  }

  updateFromgallery() async {
    await takePhoto(ImageSource.gallery);
    String? imageUrl = await uploadImage(file);
    usersDoc.where('id', isEqualTo: widget.profileId).get().then((snapshot) => {
          snapshot.docs.forEach((element) {
            usersDoc.doc(element.id).update({
              'avatar': imageUrl
            });
          })
        });
    // usersDoc.doc(widget.profileId).update({'avatar': imageUrl});
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => PageNavigator(authUser: user)),
        ));
  }

  handleUpdate() async {
    if (validatBio() && validateName() && validateId()) {
      // usersDoc.doc(widget.profileId).update({
      //   'fullName': nameController.text,
      //   'bio': bioController.text,
      // });
      usersDoc
          .where('id', isEqualTo: widget.profileId)
          .get()
          .then((snapshot) => {
                snapshot.docs.forEach((element) {
                  usersDoc.doc(element.id).update({
                    'fullName': nameController.text,
                    'bio': bioController.text,
                  });
                })
              });
      setState(() {
        file = null;
        avatorId = Uuid().v4();
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => PageNavigator(authUser: user)),
          ));
    } else {
      if (!validateName()) {
        // ignore: use_build_context_synchronously
        return showSnackBar(context,
            'your name must be 3 to 15 characters only in length', Colors.red);
      } else if (!validatBio()) {
        // ignore: use_build_context_synchronously
        return showSnackBar(
            context,
            'your bio character length must be less than 40 in length',
            Colors.red);
      } else {
        // ignore: use_build_context_synchronously
        return showSnackBar(
            context, 'Your Id character must be 8 in length', Colors.red);
      }
    }
  }

  handleLogout() {
    Navigator.pop(context);
    AuthenticationService(FirebaseAuth.instance, context).signOut();
  }

  buildProfile() {
    bool isProfileOwner = widget.profileId == currentUserId;
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
                                File(file?.path ?? ''),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    user?.avatar ?? ''),
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
              backgroundImage: CachedNetworkImageProvider(user?.avatar ?? ''),
            ),
            BuildUserInfo(
              nameController: nameController,
              bioController: bioController,
              idController: idController,
              emailController: emailController,
              phoneController: phoneController,
            )
          ],
        ),
      );
    }
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
                // onPressed: () => takePhoto(ImageSource.camera),
                onPressed: updateFromCamera,
                icon: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                // onPressed: () => takePhoto(ImageSource.gallery),
                onPressed: updateFromgallery,
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

  Widget buildEditInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 10),
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
        body: isLoading
            ? circularProgress()
            : ListView(
                children: [
                  buildProfile(),
                ],
              ));
  }
}