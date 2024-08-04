import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:notice_board/features/dashboard/pages/request/data/request_model.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/request_provider.dart';
import '../../../../../router/router.dart';
import '../../../../../router/router_items.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';

class ViewRequest extends ConsumerStatefulWidget {
  const ViewRequest(this.id, {super.key});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewRequestState();
}

class _ViewRequestState extends ConsumerState<ViewRequest> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var requestStream = ref.watch(requestStreamProvider);
    return requestStream.when(data: (data) {
      var requestList = ref.watch(requestFilterProvider).list.toList();
      var request =
          requestList.firstWhere((element) => element.id == widget.id);
      return style.largerThanMobile
          ? buildLargeScreen(request)
          : buildSmallScreen(request);
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

  Widget buildLargeScreen(RequestModel notice) {
    var style = Styles(context);
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
                    RouterItem.requestRoute,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: notice.status == 'published'
                            ? Colors.green
                            : notice.status == 'rejected'
                                ? Colors.red
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      notice.status,
                      style: style.body(color: Colors.white),
                    ),
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
                            ),
          )
        ],
      ),
    );
  }

  Widget buildSmallScreen(RequestModel notice) {
    var style = Styles(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            MyRouter(context: context, ref: ref).navigateToRoute(
              RouterItem.requestRoute,
            );
          },
        ),
        title: Text('Notice Details', style: style.title(color: Colors.black)),
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
