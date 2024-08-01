import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_drop_down.dart';
import 'package:notice_board/core/views/custom_input.dart';
import 'package:notice_board/features/affiliations/provider/affiliation_provider.dart';
import '../../../../utils/styles.dart';
import '../../../notice/provider/notice_provider.dart';
import 'notice_card.dart';

class NoticeListPage extends ConsumerStatefulWidget {
  const NoticeListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends ConsumerState<NoticeListPage> {
  @override
  Widget build(BuildContext context) {
   
    var noticeStream = ref.watch(noticeListStream);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: noticeStream.when(data: (data) {
          var noticeList = ref.watch(noticeListProvider).filteredList;
          //get upto only 10 notices if it more than ten and sort by created at
          noticeList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return Column(
            children: [
              _buildHeader(),
              const SizedBox(
                height: 20,
              ),
              if (noticeList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                    child: Text('No Notice Found'),
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.start,
                  runSpacing: 10,
                  children: [
                    for (int i = 0;
                        i < (noticeList.length > 12 ? 12 : noticeList.length);
                        i++)
                      NoticeCard(
                        notice: noticeList[i],
                      ),
                  ],
                ),
            ],
          );
        }, error: (error, stack) {
          return const Center(
            child: Text('Error loading data'),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }

  Widget _buildHeader() {
    var style = Styles(context);
    var affiliations = ref.watch(affiliationFutureProvider);
    return affiliations.when(data: (data) {
      var listOfAffiliations = data.map((e) => e.name).toList();
      //add all to the list
      listOfAffiliations.insert(0, 'All');
      if (style.largerThanMobile) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Recent Notice',
              style: style.title(fontSize: 30),
            ),
            const Spacer(),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: style.isDesktop ? 500 : style.width * .3,
              child: CustomTextFields(
                hintText: 'Search Notice',
                suffixIcon: const Icon(Icons.search),
                onChanged: (query) {
                  ref.read(noticeListProvider.notifier).search(query);
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: style.isDesktop ? 300 : style.width * .3,
              child: CustomDropDown(
                label: 'Filter by Affiliation',
                onChanged: (filter) {
                  
                  ref.read(noticeListProvider.notifier).filter(filter);
                },
                items: listOfAffiliations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
            )
          ],
        );
      } else {
        if (ref.watch(isUserSaerching)) {
          return SizedBox(
            width: double.infinity,
            child: CustomTextFields(
              hintText: 'Search Notice',
              prefixIcon: Icons.search,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref.read(isUserSaerching.notifier).state = false;
                },
              ),
              onChanged: (notice) {
                ref.read(noticeListProvider.notifier).search(notice);
              },
            ),
          );
        } else if (ref.watch(isUserFiltering)) {
          return SizedBox(
            width: double.infinity,
            child: CustomDropDown(
              hintText: 'Filter by Affiliation',
              onChanged: (filter) {
               // ref.read(selectedAffiliation.notifier).state = filter;
                ref.read(noticeListProvider.notifier).filter(filter);
              },
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref.read(isUserFiltering.notifier).state = false;
                },
              ),
              items: listOfAffiliations
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          );
        }
        return Row(
          children: [
            Text(
              'Recent Notice',
              style: style.title(fontSize: 20),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                ref.read(isUserFiltering.notifier).state = true;
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(isUserSaerching.notifier).state = true;
              },
            ),
          ],
        );
      }
    }, error: (error, stack) {
      return const SizedBox.shrink();
    }, loading: () {
      return const CircularProgressIndicator();
    });
  }
}
