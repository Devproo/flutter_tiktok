import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tiktok/global.dart';
import 'package:flutter_tiktok/home/upload_video/upload_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/input_text_widget.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const UploadForm({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  UploadController uploadVideoController = Get.put(UploadController());
  VideoPlayerController? playerController;
  TextEditingController artistSongTextEditingController =
      TextEditingController();
  TextEditingController descriptionTagsTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();

    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setVolume(true as double);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              child: VideoPlayer(playerController!),
            ),
            const SizedBox(
              height: 30,
            ),
            // upload now btn if user clicked
            // circular progressbar
            // input fields
            showProgressBar == true
                // ignore: avoid_unnecessary_containers
                ? Container(
                    child: const SimpleCircularProgressBar(
                      progressColors: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.red,
                        Colors.amber,
                        Colors.purpleAccent,
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // artist song
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                          textEditingController:
                              artistSongTextEditingController,
                          labelString: 'artist song',
                          iconData: Icons.music_video_sharp,
                          isObscure: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // description tag
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                          textEditingController:
                              descriptionTagsTextEditingController,
                          labelString: 'description tag',
                          iconData: Icons.slideshow_sharp,
                          isObscure: false,
                        ),
                      ),
                      // upload now button
                      Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (artistSongTextEditingController
                                    .text.isNotEmpty &&
                                descriptionTagsTextEditingController
                                    .text.isNotEmpty) {
                              uploadVideoController
                                  .saveVideoInformationToFirestoreDatabase(
                                      artistSongTextEditingController.text,
                                      descriptionTagsTextEditingController.text,
                                      widget.videoPath,
                                      context);
                              setState(() {
                                showProgressBar = true;
                              });
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Upload Now',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
