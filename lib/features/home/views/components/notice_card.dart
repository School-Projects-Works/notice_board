import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:notice_board/router/router.dart';
import 'package:notice_board/router/router_items.dart';
import '../../../../constants/constant_data.dart';
import '../../../../core/functions/int_to_date.dart';
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
    var width = style.isMobile
        ? style.width * .9
        : style.isTablet
            ? style.width * .35
            : style.width * .3;
    return InkWell(
      onTap: () {
        MyRouter(context: context, ref: ref).navigateToNamed(
            pathPrams: {'noticeId': notice.id},
            item: RouterItem.noticeDetailsRoute);
      },
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
          width: width,
          height: width + 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (notice.images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child:  ImageNetwork(
                      image: notice.images[0],
                     onTap: () {
                        MyRouter(context: context, ref: ref).navigateToNamed(
                            pathPrams: {'noticeId': notice.id},
                            item: RouterItem.noticeDetailsRoute);
                      },
                      width: style.isMobile
                          ? style.width * .9
                          : style.isTablet
                              ? style.width * .35
                              : style.width * .3,
                      fitAndroidIos: BoxFit.fill,
                      fitWeb: BoxFitWeb.fill,
                      height: 200),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('For: ${notice.affliation.join(', ')} Students',
                    style: style.body(color: Colors.black45, fontSize: 14)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Text(
                  notice.title,
                  style: style.title(
                    color: darkColors[int],
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Markdown(
                  selectable: true,
                  shrinkWrap: true,
                  onTapText: () {
                    MyRouter(context: context, ref: ref).navigateToNamed(
                        pathPrams: {'noticeId': notice.id},
                        item: RouterItem.noticeDetailsRoute);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  data: notice.description.length > 400
                      ? '${notice.description.substring(0, 390)}...Click to read more'
                      : '${notice.description}... Click to read less',
                  styleSheet: MarkdownStyleSheet(
                    p: style.body(color: Colors.black45, fontSize: 14),
                    h1: style.body(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                  width: width,
                  color: darkColors[int],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Posted on: ${intToDate(notice.createdAt, withTime: true)}',
                    style: style.body(color: Colors.white, fontSize: 14),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
