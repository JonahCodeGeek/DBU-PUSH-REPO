// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/screens/pages/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import '../../widgets/app_button.dart';
import 'channel_eddit.dart';

class PublicDetail extends StatefulWidget {
  final String docId;

  PublicDetail({Key? key, required this.docId}) : super(key: key);

  @override
  State<PublicDetail> createState() => _PublicDetailState();
}

class _PublicDetailState extends State<PublicDetail> {
  final database = FirebaseFirestore.instance.collection('channels');
  List channel = [];

  getResult() async {
    await database.doc(widget.docId).get().asStream().forEach((element) {
      // print(widget.docId);

      setState(() {
        return channel.add(element);
      });
    });
  }

  @override
  initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    // );

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: ((context, index) {
            return Column(
              children: [
                Stack(
                  children: [
                    Column(children: [
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(channel[index]['backgroundImage']),
                          ),
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        VerticalSpacer(160),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 45,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            channel[index]['avatar']),
                                      ),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Column(
                                children: [
                                  VerticalSpacer(70),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 85.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Created on ' +
                                            channel[index]['created'],
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            color: AppColors.textColor3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //channel information
                      ],
                    ),
                  ],
                ),
                //this is where i will add all the
                VerticalSpacer(5),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          channel[index]['name'].toString().toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.group,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                VerticalSpacer(1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      channel[index]['bio'],
                      style: GoogleFonts.roboto(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                VerticalSpacer(3),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      channel[index]['username'],
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppColors.textColor3,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      channel[index]['members'].length.toString() + ' members',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppColors.textColor3,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 18.0),
                      child: AppButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) =>
                                  EditChannel(docId: widget.docId)),
                            ),
                          );
                        },
                        text: 'edit',
                        width: 100,
                        buttonColor: AppColors.primaryColor,
                        fontColor: AppColors.scaffoldColor,
                        buttonShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
                VerticalSpacer(8),
                Divider(
                  height: 15,
                  thickness: 0.4,
                  indent: 5,
                  endIndent: 5,
                  color: AppColors.textColor3,
                ),
              ],
            );
          }),
          itemCount: channel.length),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => CreatePost(docId: widget.docId)),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
