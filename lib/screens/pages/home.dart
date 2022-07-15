import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/screens/pages/profile.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:dbu_push/widgets/build_no_content_search.dart';
import 'package:dbu_push/widgets/circle_button.dart';
import 'package:dbu_push/widgets/progress.dart';
import 'package:dbu_push/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  tapProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Profile())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            floating: true,
            leading: CircleButton(
                icon: Icons.search,
                iconSize: 30,
                onPressed: () {
                  showSearch(context: context, delegate: ContentSearch());
                }),
            actions: [
              CircleButton(
                  icon: Icons.account_circle,
                  iconSize: 30,
                  onPressed: tapProfile)
            ],
          ),
        ],
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
    return FutureBuilder<QuerySnapshot>(
      future: usersDoc.where('fullName', isGreaterThanOrEqualTo: query).get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        if (query == '') {
          return BuildNoContent();
        }

        List<UserResult> searchSnapshots = [];
        snapshot.data?.docs.map((doc) {
          User user = User.fromDocument(doc);
          UserResult results = UserResult(user);
          searchSnapshots.add(results);
        }).toList();
        return ListView(
          children: searchSnapshots,
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: usersDoc.where('fullName', isGreaterThanOrEqualTo: query).get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        List<UserResult> searchSnapshots = [];

        if (query == '') {
          return BuildNoContent();
        }
        snapshot.data?.docs.map((doc) {
          User user = User.fromDocument(doc);
          UserResult results = UserResult(user);
          searchSnapshots.add(results);
        }).toList();
        return ListView(
          children: searchSnapshots,
        );
      }),
    );
  }
}
