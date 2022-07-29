
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
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
  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersDoc.doc('O6DlpswReyWvbFnjUbHA').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data!);

        return Padding(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.avatar!),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      child: buildIconButton(AppColors.primaryColor),
                      //on tap edit profile
                      onTap: () => print(' profile buttontapped'),
                    ),
                  ),
                ],
              ),
              buildUserInfo(user)
            ],
          ),
        );
      },
    );
  }

  Padding buildUserInfo(User user) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            user.fullName!,
            style: TextStyle(
                color: AppColors.textColor1,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          Text(
            textAlign: TextAlign.center,
            user.phone!,
            style: TextStyle(
                color: AppColors.textColor2,
                fontWeight: FontWeight.w300,
                fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            // textAlign: TextAlign.center,
            user.bio!,
            style: TextStyle(
                color: AppColors.textColor3,
                fontWeight: FontWeight.normal,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildProfileBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 30),
      child: Column(
        children: [
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('hello home'),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
            ),
          ),
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('hello notfications'),
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notfications'),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('new channel'),
              child: ListTile(
                leading: Icon(Icons.telegram),
                title: Text('New Channel'),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('private channels'),
              child: ListTile(
                leading: Icon(Icons.group_work),
                title: Text('private channels'),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('public channels'),
              child: ListTile(
                leading: Icon(Icons.podcasts),
                title: Text('public channels'),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white70,
            shadowColor: Colors.white54,
            child: GestureDetector(
              onTap: () => print('logout'),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('logout'),
              ),
            ),
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
          buildProfileHeader(),
          Divider(),
          buildProfileBody(),
        ],
      ),
    );
  }
}
