import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChannelModel {
  final String? id;
  final String? username;
  final String? avatar;
  final String? backgroundImage;
  final String? bio;
  final String? created;
  final String? creator;
  final List? members;
  final List? posts;
  final String? type;
  ChannelModel(
      {this.id,
      this.avatar,
      this.backgroundImage,
      this.bio,
      this.created,
      this.creator,
      this.members,
      this.posts,
      this.type,
      this.username});
  factory ChannelModel.fromDocument(DocumentSnapshot doc) {
    return ChannelModel(
      username: doc.get('username'),
      avatar: doc.get('avatar'),
      backgroundImage: doc.get('backgroundImage'),
      bio: doc.get('bio'),
      members: doc.get('members'),
      creator: doc.get('creator'),
      created: doc.get('created'),
      posts: doc.get('posts'),
      type: doc.get('type'),
    );
  }
}
