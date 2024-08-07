import 'package:flutter/material.dart';
import 'package:frontend/screens/community/post_detail_screen.dart';
import 'package:frontend/screens/community/widget/post_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

import '../../../../model/data/post/post.dart';

class PostItemCard extends StatelessWidget {
  final Post post;

  const PostItemCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // 문자열을 DateTime 객체로 파싱
    DateTime date = DateTime.parse(post.createdDate.toString());

    // 날짜 형식 변경
    String beforeHours = calculateBeforeHours(date);

    return GestureDetector(
        onTap: () {
          Get.put(() => PostDetailScreen(post: post));
        },
        child: Container(
            // color: Palette.grey300,
            // height: screenSize.height * 0.23,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide.none,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      articleImage(screenSize),
                      const SizedBox(height: 2),
                      Text(
                        post.title,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Palette.grey500,
                          fontSize: 11,
                          fontFamily: 'Pretender',
                        ),
                      ),
                      const SizedBox(height: 2),
                      // userInform(post.avatar, post.author.name), //Todo : post image
                      const SizedBox(height: 2),
                      articleInform(),
                      Text(
                        "   $beforeHours",
                        style: const TextStyle(
                            fontFamily: 'Pretender',
                            fontSize: 9,
                            color: Palette.grey200),
                      ),
                    ]))));
  }

  Widget articleImage(Size screenSize) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        post.image, // 이미지 경로 article.image
        fit: BoxFit.cover,
        width: screenSize.width * 0.35,
        height: screenSize.width * 0.35 * (3 / 4),
      ),
    );
  }

  Widget userInform(String image, String name) {
    // String uploadTimeString = formatDate(uploadTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5), // Add some space between the image and text
        CircleAvatar(
          radius: 10,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(width: 5), // Add some space between the image and text
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
            style: const TextStyle(
                fontFamily: 'Pretender',
                fontSize: 10,
                color: Palette.purPle300,
                fontWeight: FontWeight.w500),
          ),
          // Text(
          //   uploadTimeString,
          //   style: const TextStyle(
          //       fontFamily: 'Pretender',
          //       fontSize: 11,
          //       color: Palette.grey200),
          // ),
        ]),
      ],
    );
  }

  Widget articleInform() {
    TextStyle numberStyle = const TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Pretender",
        fontSize: 10,
        color: Palette.grey200);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 5), // Add some space between the image and text

        const Icon(Icons.comment_outlined, color: Palette.grey200, size: 15),
        const SizedBox(width: 5),
        Text(post.comments.length.toString(), style: numberStyle),
        const SizedBox(width: 10),
        const Icon(Icons.thumb_up_outlined, color: Palette.grey200, size: 15),
        const SizedBox(width: 5),
        Text(post.comments.length.toString(), //좋아요 개수로 바꿔야함
            style: numberStyle)
      ],
    );
  }
}
