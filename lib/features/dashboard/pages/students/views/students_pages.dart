import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/dashboard/pages/students/provider/students_provider.dart';

import '../../../../../core/views/custom_dialog.dart';
import '../../../../../core/views/custom_input.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';

class StudentsPages extends ConsumerStatefulWidget {
  const StudentsPages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentsPagesState();
}

class _StudentsPagesState extends ConsumerState<StudentsPages> {

  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var students = ref.watch(studentsProvider).filter;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students'.toUpperCase(),
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
                  hintText: 'Search a student',
                  onChanged: (query) {
                    ref.read(studentsProvider.notifier).filterList(query);
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
                    fixedWidth: styles.isMobile ? null : 120),
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
              rows: List<DataRow>.generate(students.length, (index) {
                var student = students[index];
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
                            image: student.image != null
                                ? DecorationImage(
                                    image: NetworkImage(student.image!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: student.image == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ),
                    DataCell(Text(student.name, style: rowStyles)),
                    DataCell(Text(student.email, style: rowStyles)),
                    DataCell(Text(student.phone, style: rowStyles)),
                    DataCell(Text(student.affiliations.join(','),
                        style: rowStyles)),
                    DataCell(Container(
                        width: 90,
                        // alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: student.status == 'active'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(student.status,
                            style: rowStyles.copyWith(color: Colors.white)))),
                    DataCell(
                      Row(
                        children: [
                          //iconn button to block and unblock user
                          if (student.status == 'active')
                            IconButton(
                              onPressed: () {
                                CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to block ${student.name}?',
                                    secondBtnText: 'Block',
                                    onConfirm: () {
                                      ref
                                          .read(studentsProvider.notifier)
                                          .block(student);
                                    });
                              },
                              icon: const Icon(
                                Icons.block,
                                color: Colors.red,
                              ),
                            ),
                          if (student.status == 'banned')
                            IconButton(
                              onPressed: () {
                                CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to unblock ${student.name}?',
                                    secondBtnText: 'Unblock',
                                    onConfirm: () {
                                      ref
                                          .read(studentsProvider.notifier)
                                          .unblock(student);
                                    });
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ),
                            //make student a secretary icon
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
