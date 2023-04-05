// ignore_for_file: unused_local_variable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tiktok/authentication/login_screen.dart';
import 'package:flutter_tiktok/authentication/registration_screen.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart' as userModel;

class AuthenticationController extends GetxController {
  late Rx<user?> _currentUser;
  late Rx<File> _pickedFile;
  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      Get.snackbar(
        'Profile Image',
        'you have selected profile image',
      );
    }
    _pickedFile = Rx<File>(File(pickedImageFile!.path));
  }

  void captureImageWthCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      Get.snackbar(
        'Profile Image',
        'you have selected profile image',
      );
    }

    _pickedFile = Rx<File>(File(pickedImageFile!.path));
  }

  void createAccountForNewUser(File imageFile, String userName,
      String userEmail, String userPassword) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      String imageDownloadUrl = await uploadImageToStorage(imageFile);

      userModel.User user = userModel.User(
        name: userName,
        email: userEmail,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toJson());
    } catch (error) {
      Get.snackbar('Account creation insuccessful', 'error occurred');
      showProgressBar = false;
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Profile Image')
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrlOfUploadingImage =
        await taskSnapshot.ref.getDownloadURL();
    return downloadUrlOfUploadingImage;
  }

  void loginUserNow() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      Get.snackbar(' logged successfully', 'error occurred');
      showProgressBar = false;
      Get.to(const RegistrationScreen());
    } catch (error) {
      Get.snackbar('login unsuccessful', 'error occurred');
      showProgressBar = false;
    }
  }

  goToScreen(User? currentUser) {
    // when user is not logged in
    if (currentUser == null) {
      Get.offAll(const LoginScreen());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, goToScreen);
  }
}
