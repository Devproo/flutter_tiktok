import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String? userID;
  String? userName;
  String? userProfileImage;
  String? videoID;
  int? totalComments;
  int? totalShare;
  List? likeList;
  String? artistSongName;
  String? descriptionTags;
  String? videoUrl;
  String? thumbnailUrl;
  int? publishedDateTime;
  Video({
    this.userID,
    this.userName,
    this.userProfileImage,
    this.videoID,
    this.totalComments,
    this.totalShare,
    this.likeList,
    this.artistSongName,
    this.descriptionTags,
    this.videoUrl,
    this.thumbnailUrl,
    this.publishedDateTime,
  });
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userName': userName,
        'userProfileImage': userProfileImage,
        'videoID': videoID,
        'totalComments': totalComments,
        'totalShare': totalShare,
        'likeList': likeList,
        'aristSongName': artistSongName,
        'descriptionTags': descriptionTags,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'publishedDteTime': publishedDateTime,
      };
  static Video fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Video(
      userID: docSnapshot['userID'],
      userName: docSnapshot['userName'],
      userProfileImage: docSnapshot['userProfileImage'],
      videoID: docSnapshot['videoID'],
      totalComments: docSnapshot['totalComments'],
      totalShare: docSnapshot['totalShares'],
      likeList: docSnapshot['likeList'],
      artistSongName: docSnapshot['artistSongName'],
      descriptionTags: docSnapshot['descriptionTags'],
      videoUrl: docSnapshot['videoUrl'],
      thumbnailUrl: docSnapshot['thumbnailUrl'],
      publishedDateTime: docSnapshot['publishedDateTime'],
    );
  }
}
