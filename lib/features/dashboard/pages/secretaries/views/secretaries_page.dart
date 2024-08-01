import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/dashboard/pages/secretaries/provider/secretaries_provider.dart';
import '../../../../../core/views/custom_input.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';

class SecretariesPage extends ConsumerStatefulWidget {
  const SecretariesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecretariesPageState();
}

class _SecretariesPageState extends ConsumerState<SecretariesPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var secretaries = ref.watch(secretariesProvider).filterList;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Secretaries'.toUpperCase(),
            style: styles.title(fontSize: 35, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: styles.width * .5,
                child: CustomTextFields(
                  hintText: 'Search a Secretary',
                  onChanged: (query) {
                    ref.read(secretariesProvider.notifier).filter(query);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
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
                'No Secretary found',
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
                    label: Text('Image'.toUpperCase()),
                    size: ColumnSize.S,
                    fixedWidth: styles.isMobile ? null : 80),
                DataColumn2(
                  label: Text('Name'.toUpperCase()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('email'.toUpperCase()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                    label: Text('Phone'.toUpperCase()),
                    size: ColumnSize.M,
                    fixedWidth: styles.isMobile ? null : 100),
                DataColumn2(
                  label: Text('Affiliations'.toString()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Status'.toUpperCase()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 100,
                ),
                DataColumn2(
                  label: Text('Action'.toUpperCase()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
              ],
              rows: List<DataRow>.generate(secretaries.length, (index) {
                var secretary = secretaries[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: secretary.image != null
                                ? DecorationImage(
                                    image: NetworkImage(secretary.image!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: secretary.image == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ),
                    DataCell(Text(secretary.name, style: rowStyles)),
                    DataCell(Text(secretary.email, style: rowStyles)),
                    DataCell(Text(secretary.phone, style: rowStyles)),
                    DataCell(Text(secretary.affiliations.join(','),
                        style: rowStyles)),
                    DataCell(Container(
                        width: 90,
                        // alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: secretary.status == 'active'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(secretary.status,
                            style: rowStyles.copyWith(color: Colors.white)))),
                    DataCell(
                      Row(
                        children: [
                          //iconn button to block and unblock user
                          if (secretary.status == 'active')
                            IconButton(
                              onPressed: () {
                                CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to block ${secretary.name}?',
                                    secondBtnText: 'Block',
                                    onConfirm: () {
                                      ref
                                          .read(secretariesProvider.notifier)
                                          .block(secretary);
                                    });
                              },
                              icon: const Icon(
                                Icons.block,
                                color: Colors.red,
                              ),
                            ),
                          if (secretary.status == 'banned')
                            IconButton(
                              onPressed: () {
                                CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to unblock ${secretary.name}?',
                                    secondBtnText: 'Unblock',
                                    onConfirm: () {
                                      ref
                                          .read(secretariesProvider.notifier)
                                          .unblock(secretary);
                                    });
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ),
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
