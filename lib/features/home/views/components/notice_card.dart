import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/constant_data.dart';
import '../../../../utils/styles.dart';
import '../../../notice/data/notice_model.dart';

class NoticeCard extends ConsumerStatefulWidget {
  const NoticeCard({super.key, required this.notice});
  final NoticeModel notice;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticeCardState();
}

class _NoticeCardState extends ConsumerState<NoticeCard> {
  bool isHover = false;
  final int = Random().nextInt(darkColors.length);
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var notice = widget.notice;

    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      child: Card(
        color: Colors.white,
        elevation: isHover ? 5 : 1,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: style.isMobile
              ? style.width * .9
              : style.isTablet
                  ? style.width * .35
                  : style.width * .3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (notice.images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.network(notice.images[0],
                      width: style.isMobile
                          ? style.width * .9
                          : style.isTablet
                              ? style.width * .35
                              : style.width * .3,
                      fit: BoxFit.fill,
                      height: 200),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  notice.title,
                  style: style.title(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Markdown(
                  selectable: true,
                  data: notice.description,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
