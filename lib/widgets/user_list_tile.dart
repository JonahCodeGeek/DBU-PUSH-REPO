import 'package:cached_network_image/cached_network_image.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/screens/pages/profile.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:flutter/material.dart';

class UserResult extends StatelessWidget {
  final UserModel user;
  const UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => Profile(profileId: user.id)),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.avatar ?? ''),
              ),
              title: Text(
                user.fullName!,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.email!,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
