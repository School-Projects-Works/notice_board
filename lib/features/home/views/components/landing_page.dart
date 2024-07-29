import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/generated/assets.dart';
import 'package:notice_board/utils/colors.dart';

import '../../../../utils/styles.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, String>> slides = [
      {
        "title": "Welcome to Notice Board",
        "description":
            "Get the latest news and updates from your school and department",
        "image": Assets.slidesSlide1
      },
      {
        "title": "Get Notified",
        "description":
            "Get notified on the latest news and updates from your school",
        "image": Assets.slidesSlide2
      },
      {
        "title": "Stay Updated",
        "description":
            "Stay updated on the latest news and updates from your school",
        "image": Assets.slidesSlide3
      }
    ];
    var style = Styles(context);
    return CarouselSlider(
      options: CarouselOptions(
        height: 400.0,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
      items: slides.map((slide) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              width: style.width,
              child: Stack(
                children: [
                  Positioned(
                    left: 30,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      slide["image"]!,
                      width: style.width * 0.4,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: !style.isDesktop ? style.width : style.width * 0.4,
                      alignment: Alignment.center,
                      color: !style.isDesktop
                          ? Colors.black.withOpacity(0.5)
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slide["title"]!,
                              textAlign: TextAlign.center,
                              style: style.title(
                                  color: !style.isDesktop
                                      ? Colors.white
                                      : primaryColor,
                                  fontSize: style.isDesktop
                                      ? 42
                                      : style.isTablet
                                          ? 32
                                          : 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              slide["description"]!,
                              textAlign: TextAlign.center,
                              style: style.body().copyWith(
                                  color: !style.isDesktop
                                      ? Colors.white60
                                      : Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
