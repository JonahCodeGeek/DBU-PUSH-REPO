// ignore_for_file: prefer_const_constructors_in_immutables, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/Theme/app_colors.dart';

class DefaultPosts extends StatefulWidget {
  DefaultPosts({Key? key}) : super(key: key);

  @override
  State<DefaultPosts> createState() => _DefaultPostsState();
}

class _DefaultPostsState extends State<DefaultPosts> {
  String channelId = '';
  List posts = [];
  List channels = [];
  final CollectionReference channel =
      FirebaseFirestore.instance.collection('channels');
  final CollectionReference _postReference =
      FirebaseFirestore.instance.collection('posts');
  Future<void> getDefaultPost() async {
    // Get channel id  from collection
    await channel.where('type', isEqualTo: 'default').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          channelId = element.id;
        });
      });
    }).then((value) async {
      //search for the post that contains this channel id
      await channel.doc(channelId).get().asStream().forEach((element) {
        setState(() {
          return channels.add(element);
        });
      });
      await _postReference
          .where('channel', isEqualTo: channelId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            return posts.add(element);
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDefaultPost();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: List.generate(
            posts.length,
            (index) {
              return Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(posts[index]['channel_image']),
                            ),
                          ),
                        ),
                      ),
                      title: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          posts[index]['message'],
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                      ),
                    ),
                    VerticalSpacer(10),
                    Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 5),
                      child: posts[index]['media_url'] != ''
                          ? Container(
                              width: double.maxFinite,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    (posts[index]['media_url']),
                                  ),
                                ),
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          : SizedBox(),
                    )
                  ]);
            },
          ),
        ),
      ],
    );
  }
}
