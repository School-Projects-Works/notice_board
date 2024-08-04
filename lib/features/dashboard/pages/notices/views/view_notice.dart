import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notice_board/features/notice/provider/notice_provider.dart';

import '../../../../../core/functions/int_to_date.dart';
import '../../../../../core/views/custom_dialog.dart';
import '../../../../../core/views/custom_input.dart';
import '../../../../../router/router.dart';
import '../../../../../router/router_items.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';
import '../../../../comments/provider/comment_provider.dart';
import '../../../../notice/data/notice_model.dart';

class ViewNotice extends ConsumerStatefulWidget {
  const ViewNotice({super.key, required this.noticeId});
  final String noticeId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewNoticeState();
}

class _ViewNoticeState extends ConsumerState<ViewNotice> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var noticeStream = ref.watch(noticeListStream);
    return noticeStream.when(data: (data) {
      var noticeList = ref.watch(noticeListProvider).noticeRawList.toList();
      var notice =
          noticeList.firstWhere((element) => element.id == widget.noticeId);
      return style.largerThanMobile
          ? buildLargeScreen(notice)
          : buildSmallScreen(notice);
    }, error: (error, stack) {
      return const Center(
        child: Text('Error Fetching Data'),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget buildLargeScreen(NoticeModel notice) {
    var style = Styles(context);
    var comments = ref.watch(commentStream(notice.id));
    var user = ref.watch(userProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: style.isDesktop ? style.width * .5 : style.width * .6,
      child: Column(
        children: [
          Row(
            children: [
              //close button
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  MyRouter(context: context, ref: ref).navigateToRoute(
                    RouterItem.noticeRoute,
                  );
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text('Notice Details',
                  style: style.title(
                    color: Colors.black,
                    fontSize: 35,
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notice.images.isNotEmpty)
                          CarouselSlider(
                              items: [
                                for (var image in notice.images)
                                  ImageNetwork(
                                    image: image,
                                    width: 600,
                                    height: 300,
                                    fitAndroidIos: BoxFit.fill,
                                    fitWeb: BoxFitWeb.fill,
                                  )
                              ],
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 3),
                              )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                                'For: ${notice.affliation.join(', ')} Students',
                                style: style.body(
                                    color: Colors.black45, fontSize: 14)),
                          ],
                        ),
                        if (style.isMobile)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: notice.status=='published'?Colors.green:notice.status=='rejected'?Colors.red:Colors.grey,
                                borderRadius: BorderRadius.circular(5)),
                                child: Text(notice.status, style: style.body(color: Colors.white),),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          notice.title,
                          style: style.title(color: primaryColor, fontSize: 35),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Markdown(
                          selectable: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          data: notice.description,
                          styleSheet: MarkdownStyleSheet(
                            p: style.body(color: Colors.black45, fontSize: 14),
                            h1: style.body(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  )),
                )),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  height: style.height * .8,
                  width: style.isDesktop ? style.width * .4 : style.width * .4,
                  child: comments.when(
                    data: (data) {
                      return Column(children: [
                        Text('Notice Comments (${data.length})',
                            style: style.subtitle(color: Colors.black54)),
                        const Divider(),
                        //list of comments
                        if (data.isEmpty)
                          const Center(
                            child: Text('No Comments Yet'),
                          ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                          children: [
                            for (var comment in data)
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(comment.userName,
                                        style: style.body(
                                            color: Colors.black54,
                                            fontSize: 16)),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.comment,
                                      style: style.body(
                                          color: Colors.black45, fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      intToDate(comment.createdAt),
                                      style: style.body(
                                          color: Colors.black45, fontSize: 14),
                                    ),
                                    const Divider(
                                      height: 10,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ))),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFields(
                            hintText: 'Enter Comment',
                            maxLines: 3,
                            controller: _commentController,
                            suffixIcon: _commentController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      if (user.id.isEmpty) {
                                        CustomDialogs.toast(
                                          message: 'Please Login to Comment',
                                        );
                                        return;
                                      }
                                      ref
                                          .read(newCommentProvider.notifier)
                                          .addComment(
                                              noticeId: notice.id,
                                              comment: _commentController.text,
                                              ref: ref);
                                      _commentController.clear();
                                    },
                                  )
                                : const SizedBox.shrink(),
                            onChanged: (comment) {
                              setState(() {
                                _commentController.text = comment;
                              });
                            },
                          ),
                        )
                      ]);
                    },
                    error: (error, stack) {
                      return const Center(
                        child: Text('Error Fetching Data'),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSmallScreen(NoticeModel notice) {
    var style = Styles(context);
    var comments = ref.watch(commentStream(notice.id));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            MyRouter(context: context, ref: ref).navigateToRoute(
              RouterItem.homeRoute,
            );
          },
        ),
        title: Text('Notice Details', style: style.title(color: Colors.black)),
      ),
      bottomSheet: comments.when(
        data: (data) {
          return InkWell(
            onTap: () {
              showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                context: context,
                builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      height: style.height * .8,
                      margin:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          //close button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: Text(
                                        'Notice Comments (${data.length})',
                                        style: style.subtitle(
                                            color: Colors.black54))),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _commentController.clear();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          //list of comments
                          if (data.isEmpty)
                            const Center(
                              child: Text('No Comments Yet'),
                            ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                for (var comment in data)
                                  ListTile(
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(comment.userName,
                                            style: style.body(
                                                color: Colors.black54,
                                                fontSize: 16)),
                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.comment,
                                          style: style.body(
                                              color: Colors.black45,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          intToDate(comment.createdAt),
                                          style: style.body(
                                              color: Colors.black45,
                                              fontSize: 14),
                                        ),
                                        const Divider(
                                          height: 10,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextFields(
                              hintText: 'Enter Comment',
                              maxLines: 2,
                              controller: _commentController,
                              suffixIcon: _commentController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        var user = ref.watch(userProvider);
                                        if (user.id.isEmpty) {
                                          CustomDialogs.toast(
                                            message: 'Please Login to Comment',
                                          );
                                          return;
                                        }
                                        ref
                                            .read(newCommentProvider.notifier)
                                            .addComment(
                                                noticeId: notice.id,
                                                comment:
                                                    _commentController.text,
                                                ref: ref);
                                        _commentController.clear();
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              onChanged: (comment) {
                                setState(() {
                                  _commentController.text = comment;
                                });
                              },
                            ),
                          )
                        ],
                      ));
                }),
              );
            },
            child: Container(
                width: style.width,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Text('Notice Comments(${data.length})',
                    style: style.body(color: Colors.white, fontSize: 16))),
          );
        },
        error: (error, stack) {
          return const Center(
            child: Text('Error Fetching Data'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      body: Container(
        color: Colors.white,
        height: style.height,
        width: style.width,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (notice.images.isNotEmpty)
                CarouselSlider(
                    items: [
                      for (var image in notice.images)
                        ImageNetwork(
                          image: image,
                          width: style.width,
                          height: 200,
                          fitAndroidIos: BoxFit.fill,
                          fitWeb: BoxFitWeb.fill,
                        )
                    ],
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 3),
                    )),
              const SizedBox(
                height: 10,
              ),
              Text('For: ${notice.affliation.join(', ')} Students',
                  style: style.body(color: Colors.black45, fontSize: 14)),
              const SizedBox(
                height: 10,
              ),
              Text(
                notice.title,
                style: style.title(color: primaryColor, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Markdown(
                selectable: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data: notice.description,
                styleSheet: MarkdownStyleSheet(
                  p: style.body(color: Colors.black45, fontSize: 14),
                  h1: style.body(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
