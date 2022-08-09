// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/screens/pages/create_channels.dart';
import 'package:dbu_push/screens/pages/profile.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:dbu_push/widgets/build_no_content_search.dart';
import 'package:dbu_push/widgets/circle_button.dart';
import 'package:dbu_push/widgets/progress.dart';
import 'package:dbu_push/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

User? currentUser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final database = FirebaseFirestore.instance;

  bool isVisible = false;
  tapProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => Profile(
              profileId: currentUser?.id,
            )),
      ),
    );
  }

  authorize() async {
    final query1 = database
        .collection('users')
        .where('id', isEqualTo: currentUser?.id)
        .where('role', isEqualTo: 'student')
        .limit(1);
    final result = await query1.get();
    final isStudent = result.docs;
    if (isStudent.isNotEmpty) {
      setState(() {
        isVisible == isVisible;
      });
    } else {
      setState(() {
        isVisible = !isVisible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    authorize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              // backgroundColor: Colors.black,
              elevation: 0,
              floating: true,
              leading: CircleButton(
                icon: Icons.search_rounded,
                iconSize: 35,
                onPressed: () {
                  showSearch(context: context, delegate: ContentSearch());
                },
              ),

              actions: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 12.0, 12, 0),
                  child: GestureDetector(
                    onTap: tapProfile,
                    child: CircleAvatar(
                      radius: 17.5,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          currentUser?.avatar ?? 'ss'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => CreateChannels()),
            ),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ContentSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildStream();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildStream();
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStream() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          usersDoc.where('fullName', isGreaterThanOrEqualTo: query).snapshots(),
      builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        if (query.isEmpty) {
          return BuildNoContent();
        }
        List<UserResult> searchList = [];
        snapshot.data?.docs.map((doc) {
          User user = User.fromDocument(doc);
          UserResult results = UserResult(user);
          searchList.add(results);
        }).toList();
        return ListView(
          children: searchList,
        );
      }),
    );
  }
}
