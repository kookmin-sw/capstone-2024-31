import 'package:flutter/material.dart';
import 'package:frontend/screens/challenge/detail/challenge_image_detail_screen.dart';
import 'package:frontend/screens/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/screens/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/screens/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/screens/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/screens/challenge/join/join_challenge_screen.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/widgets/rtu_button.dart';
import 'package:frontend/widgets/rtu_divider.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../model/controller/user_controller.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;
  final bool isFromMainScreen;
  final bool isFromMypage;
  final bool isFromPrivateCodeDialog;

  const ChallengeDetailScreen(
      {super.key,
      required this.challenge,
      this.isFromMainScreen = false,
      this.isFromMypage = false,
      this.isFromPrivateCodeDialog = false});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final logger = Logger();
  final UserController userController = Get.find();

  late Challenge _challenge;
  late bool _isMyChallenge;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    _isMyChallenge = userController.myChallenges
        .any((challenge) => challenge.id == _challenge.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.isFromMainScreen || widget.isFromMypage
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Palette.grey300,
                ),
                onPressed: () {
                  Get.back();
                })
            : IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Palette.grey300,
                ),
                onPressed: () {
                  Get.offAll(() => const MainScreen(
                        tabNumber: 0,
                      ));
                }),
        title: const Text(
          "챌린지 자세히 보기",
          style: TextStyle(
            color: Palette.grey300,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Pretendard",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.ios_share,
                color: Palette.grey300,
              )),
        ],
      ),
      body: buildChallengeDetailBody(context, _challenge),
      bottomNavigationBar: _isMyChallenge
          ? const SizedBox.shrink()
          : buildChallengeDetailBottomNavigationBar(context, _challenge),
    );
  }

  Widget buildChallengeDetailBody(BuildContext context, Challenge challenge) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          PhotoesWidget(
            screenHeight: screenSize.height,
            imageUrl: challenge.challengeImagePaths.isNotEmpty
                ? challenge.challengeImagePaths[0]
                : '',
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InformationWidget(challenge: challenge)),
          const RtuDivider(),
          challengeExplanation(challenge),
          imageGridView(screenSize, challenge),
          const RtuDivider(),
          const SizedBox(height: 10),
          certificationExplainPicture(screenSize, challenge),
        ],
      ),
    );
  }

  Widget buildChallengeDetailBottomNavigationBar(
    BuildContext context,
    Challenge challenge,
  ) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          height: 80,
          color: Colors.transparent,
          width: double.infinity,
          child: RtuButton(
            onPressed: () {
              Get.to(() => JoinChallengeScreen(challenge: challenge));
            },
            text: "참가하기",
          ),
        ),
        Positioned(
          top: 5,
          left: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Palette.purPle700,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              " ${challenge.certificationFrequency} | ${challenge.challengePeriod}주 ",
              style: const TextStyle(
                fontSize: 11,
                fontFamily: "Pretendard",
                color: Palette.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageGridView(Size screenSize, Challenge challenge) {
    final imagePaths = challenge.challengeImagePaths;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      height: screenSize.width * 0.5 * (imagePaths.length ~/ 1.5) + 10,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChallengeImageDetailScreen(imagePath: imagePaths[index]),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget challengeExplanation(Challenge challenge) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("챌린지 소개",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Text(
            challenge.challengeExplanation,
            style: const TextStyle(
                fontSize: 10,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget certificationExplainPicture(Size screenSize, Challenge challenge) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("인증 방식",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              CertificationMethod(challenge: challenge),
              Text(
                challenge.certificationExplanation,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImageContainer(
              path: challenge.successfulVerificationImage,
              color: Palette.green,
              isSuccess: true,
              screenSize: screenSize,
            ),
            const SizedBox(width: 10),
            BuildImageContainer(
              path: challenge.failedVerificationImage,
              color: Palette.red,
              isSuccess: false,
              screenSize: screenSize,
            ),
          ],
        ),
      ],
    );
  }
}
