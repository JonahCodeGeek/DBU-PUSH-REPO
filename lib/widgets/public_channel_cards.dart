// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables
// ignore_for_file:prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user.dart';
import '../utils/helpers/custom_functions.dart.dart';
import 'progress.dart';

class PublicChannelCard extends StatefulWidget {
  const PublicChannelCard({
    Key? key,
  }) : super(key: key);

  @override
  State<PublicChannelCard> createState() => _PublicChannelCardState();
}

class _PublicChannelCardState extends State<PublicChannelCard> {
  final authId = FirebaseAuth.instance.currentUser!.uid;
  final database = FirebaseFirestore.instance;
  final List channel = [];
  final List users = [];
  final Stream<QuerySnapshot> publicChannels =
      FirebaseFirestore.instance.collection('channels').snapshots();

  //query for channel list.
  final CollectionReference _channelRef =
      FirebaseFirestore.instance.collection('channels');

  Future<void> getCardData() async {
    // Get docs from collection reference
    QuerySnapshot queryChannels =
        await _channelRef.where('type', isEqualTo: 'public').get();

    // Get data from docs and convert map to List
    queryChannels.docs.map((doc) => doc.data()).toList().forEach((document) {
      return channel.add(document);
    });
  }

  @override
  void initState() {
    super.initState();
    getCardData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _channelRef.where('type', isEqualTo: 'public').get(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgress();
          }

          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
                children: List.generate(channel.length, (cardIndex) {
              return Container(
                width: 150,
                height: 220,
                margin: EdgeInsets.only(top: 5, left: 2, right: 15),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    VerticalSpacer(20),
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 30,
                      backgroundImage: NetworkImage(
                        channel[cardIndex]['avatar'],
                      ),
                    ),
                    VerticalSpacer(10),
                    Text(channel[cardIndex]['name'], //channel information
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        )),
                    VerticalSpacer(0),
                    Text(
                      channel[cardIndex]
                          ['username'], //c //creator from firebase
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: AppColors.textColor3,
                      ),
                    ),
                    VerticalSpacer(25),
                    AppButton(
                      onPressed: () {},
                      text: 'Join',
                      buttonColor: AppColors.primaryColor,
                      fontColor: AppColors.scaffoldColor,
                      buttonShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 30,
                      width: 70,
                    )
                  ],
                ),
              );
            })),
          );
        });
  }
}
