import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/screens/pages/public_channel_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';

class PrivateChannels extends StatefulWidget {
  const PrivateChannels({Key? key}) : super(key: key);

  @override
  State<PrivateChannels> createState() => _PrivateChannelsState();
}

class _PrivateChannelsState extends State<PrivateChannels> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String docId = '';
  List channels = [];
  final CollectionReference database =
      FirebaseFirestore.instance.collection('channels');

  Future<void> listChannels() async {
    // ignore: avoid_single_cascade_in_expression_statements
    await database.where('creator', isEqualTo: uid)
      ..where('type', isEqualTo: 'private').get().then((value) {
        value.docs.forEach((element) {
          setState(() {
            docId = element.id;
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

  @override
  void initState() {
    super.initState();

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
            return ListTile(
              trailing: Text(channels[index]['created']),
              onTap: () {
                setState(() {
                  docId = channels[index]['id'];
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((_) => PublicDetail(docId: '')),
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
            );
          }),
        ),
      ),
    );
  }
}
