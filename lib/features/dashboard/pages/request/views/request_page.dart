import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/request_provider.dart';
import '../../../../../core/views/custom_dialog.dart';
import '../../../../../router/router.dart';
import '../../../../../router/router_items.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';

class RequestPage extends ConsumerStatefulWidget {
  const RequestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestPageState();
}

class _RequestPageState extends ConsumerState<RequestPage> {

  @override
  Widget build(BuildContext context) {
     var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var request = ref.watch(requestFilterProvider).filter;
    var user = ref.watch(userProvider);
    //order post by created at
    request.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request'.toUpperCase(),
            style: styles.title(fontSize: 35, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
         
          Expanded(
            child: DataTable2(
              columnSpacing: 30,
              horizontalMargin: 12,
              empty: Center(
                  child: Text(
                'No Notice found',
                style: rowStyles,
              )),
              minWidth: 600,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => primaryColor.withOpacity(0.6)),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(
                    label: Text(
                      'INDEX',
                      style: titleStyles,
                    ),
                    fixedWidth: styles.largerThanMobile ? 80 : null),
                DataColumn2(
                  label: Text('Title'.toUpperCase()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Affiliations'.toUpperCase()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('Secretary'.toString()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                    label: Text('Contact'.toUpperCase()),
                    size: ColumnSize.M,
                    fixedWidth: styles.isMobile ? null : 120),
                DataColumn2(
                  label: Text('Status'.toUpperCase()),
                  size: ColumnSize.M,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
                DataColumn2(
                  label: Text('Action'.toUpperCase()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
              ],
              rows: List<DataRow>.generate(request.length, (index) {
                var notice = request[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),
                    DataCell(Text(notice.title, style: rowStyles)),
                    DataCell(Text(notice.affliation.join(','),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: rowStyles)),
                    DataCell(Text(notice.posterName, style: rowStyles)),
                    DataCell(Text(notice.contact, style: rowStyles)),
                    DataCell(Container(
                        width: 120,
                        // alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 15),
                        decoration: BoxDecoration(
                            color: notice.status == 'published'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(notice.status,
                                style: rowStyles.copyWith(color: Colors.white)),
                          ],
                        ))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            onPressed: () {
                              MyRouter(context: context, ref: ref)
                                  .navigateToNamed(
                                item: RouterItem.viewRequestRoute,
                                pathPrams: {'id': notice.id},
                              );
                            },
                          ),
                         
                          PopupMenuButton(
                              icon: const Icon(Icons.apps),
                              onSelected: (value) {
                                if (value == 'publish') {
                                  CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to publish this notice?',
                                      secondBtnText: 'Publish',
                                      onConfirm: () {
                                        ref
                                            .read(requestFilterProvider.notifier)
                                            .publishRequest(
                                                id: notice.id,
                                                );
                                      });
                                }
                                if (value == 'reject') {
                                  CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to reject this notice?',
                                      secondBtnText: 'Reject',
                                      onConfirm: () {
                                        ref
                                            .read(requestFilterProvider.notifier)
                                            .rejectRequest(
                                                id: notice.id,
                                                );
                                      });
                                }
                                if (value == 'delete') {
                                  CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to delete this notice?',
                                      secondBtnText: 'Delete',
                                      onConfirm: () {
                                        ref
                                            .read(requestFilterProvider.notifier)
                                            .deleteNotice(notice.id);
                                      });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  if (notice.status == 'pending')
                                    const PopupMenuItem(
                                      padding:
                                          EdgeInsets.only(right: 30, left: 10),
                                      value: 'publish',
                                      child: Row(
                                        children: [
                                          Icon(Icons.publish),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Publish'),
                                        ],
                                      ),
                                    ),
                                  if (notice.status == 'pending')
                                    const PopupMenuItem(
                                      padding:
                                          EdgeInsets.only(right: 30, left: 10),
                                      value: 'reject',
                                      child: Row(
                                        children: [
                                          Icon(Icons.cancel),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Reject'),
                                        ],
                                      ),
                                    ),
                                  //delete
                                  const PopupMenuItem(
                                    padding:
                                        EdgeInsets.only(right: 30, left: 10),
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ];
                              }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  
  }
}