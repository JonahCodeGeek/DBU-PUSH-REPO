import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/screens/pages/public_channel_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List docId = [];
  List channels = [];

  bool isTeacher = false;
  final CollectionReference database =
      FirebaseFirestore.instance.collection('channels');

  Future<void> listChannels() async {
    await database.where('creator', isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          docId.add(element.id);
          return channels.add(element);
        });
        Future.delayed(Duration(seconds: -1), () {
          setState(() {
            // media = posts[0]['media_url'];
          });
        });
      });
    });
  }

  authorize() async {
    final query1 = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('role', isEqualTo: 'student')
        .limit(1);
    final result = await query1.get();
    final isStudent = result.docs;
    if (isStudent.isNotEmpty) {
      setState(() {
        isTeacher == false;
      });
    } else {
      setState(() {
        isTeacher = !isTeacher;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.scaffoldColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    authorize();
    listChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
          child: ListView.builder(
              itemCount: channels.length,
              itemBuilder: ((context, index) {
                return Visibility(
                  visible: isTeacher,
                  child: Column(
                    children: [
                      ListTile(
                        minVerticalPadding: 22,
                        trailing: Text(channels[index]['created']),
                        onTap: () {
                          setState(() {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((_) =>
                                  PublicDetail(docId: docId.elementAt(index))),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          maxRadius: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(channels[index]['avatar']),
                              ),
                            ),
                          ),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            channels[index]['username'],
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        ),
                        title: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            channels[index]['name'],
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              }))),
    );
  }
}
