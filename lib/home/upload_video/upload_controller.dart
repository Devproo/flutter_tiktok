import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/home/home_screen.dart';
import 'package:flutter_tiktok/home/upload_video/video.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  compressVideoFile(String videoFilePath) async {
    final compressedVideoFile = await VideoCompress.compressVideo(videoFilePath,
        quality: VideoQuality.LowQuality);
    return compressedVideoFile!.file;
  }

  uploadCompressedVideoFileToFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask videoUploadTask = FirebaseStorage.instance
        .ref()
        .child('All Videos')
        .child(videoID)
        .putFile(
          await compressVideoFile(videoFilePath),
        );
    TaskSnapshot snapshot = await videoUploadTask;
    String downloadOfUploadedVideo = await snapshot.ref.getDownloadURL();
    return downloadOfUploadedVideo;
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnailImage;
  }

  uploadThumbnailImageFileToFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask thumbnailUploadTask = FirebaseStorage.instance
        .ref()
        .child('All thumbnails')
        .child(videoID)
        .putFile(
          await getThumbnailImage(videoFilePath),
        );
    TaskSnapshot snapshot = await thumbnailUploadTask;
    String downloadOfUploadedThumbnail = await snapshot.ref.getDownloadURL();
    return downloadOfUploadedThumbnail;
  }

  saveVideoInformationToFirestoreDatabase(
      String artistSongName,
      String descriptionTags,
      String videoFilePath,
      BuildContext context) async {
    try {
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String videoID = DateTime.now().millisecondsSinceEpoch.toString();
// upload video to storage
      String videoDowloadUrl = await uploadCompressedVideoFileToFirebaseStorage(
          videoID, videoFilePath);
//  upload thumbnail to firestore storage

      String thumbnailDownloadUrl =
          await uploadThumbnailImageFileToFirebaseStorage(
              videoID, videoFilePath);
// save overall video info to firestore database
      Video videoObject = Video(
          userID: FirebaseAuth.instance.currentUser!.uid,
          userName:
              (userDocumentSnapshot.data() as Map<String, dynamic>)['name'],
          userProfileImage:
              (userDocumentSnapshot.data() as Map<String, dynamic>)['image'],
          videoID: videoID,
          totalComments: 0,
          totalShare: 0,
          likeList: [],
          artistSongName: artistSongName,
          descriptionTags: descriptionTags,
          videoUrl: videoDowloadUrl,
          thumbnailUrl: thumbnailDownloadUrl,
          publishedDateTime: DateTime.now().millisecondsSinceEpoch);
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .set(videoObject.toJson());
      Get.to(const HomeScreen());
      Get.snackbar('New Video', 'successfully uploaded your new  video');
      showProgressBar = false;
    } catch (errorMsg) {
      Get.snackbar('uploaded unsuccessfully', 'not uploaded try again');
    }
  }
}
