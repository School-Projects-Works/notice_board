import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_button.dart';
import 'package:notice_board/core/views/custom_drop_down.dart';
import 'package:notice_board/core/views/custom_input.dart';
import 'package:notice_board/features/dashboard/pages/affiliations/provider/dash_affi_provider.dart';
import 'package:notice_board/features/dashboard/pages/students/provider/students_provider.dart';
import 'package:notice_board/features/notice/provider/notice_provider.dart';
import 'package:notice_board/utils/colors.dart';
import 'package:notice_board/utils/styles.dart';
import '../../../../../core/views/custom_dialog.dart';

class AffiliationsPage extends ConsumerStatefulWidget {
  const AffiliationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AffiliationsPageState();
}

class _AffiliationsPageState extends ConsumerState<AffiliationsPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var affiliations = ref.watch(dashAffiliationProvider).filter;
    var notice = ref.watch(noticeListProvider).noticeRawList;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Affiliations'.toUpperCase(),
            style: styles.title(fontSize: 35, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          if (!ref.watch(isNewAffiliation))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: styles.width * .5,
                  child: CustomTextFields(
                    hintText: 'Search affiliation',
                    onChanged: (query) {
                      ref
                          .read(dashAffiliationProvider.notifier)
                          .filterList(query);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomButton(
                  text: 'Add Affiliation',
                  onPressed: () {
                    ref.read(isNewAffiliation.notifier).state = true;
                    ref.read(editAffiliationProvider.notifier).reset();
                  },
                )
              ],
            ),
          if (ref.watch(isNewAffiliation)) _buildAddAffiliation(),
          if (ref.watch(editAffiliationProvider).id.isNotEmpty)
            _buildEditAffiliation(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 30,
              horizontalMargin: 12,
              empty: Center(
                  child: Text(
                'No Affiliations added',
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
                  label: Text('Name'.toUpperCase()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Secretary'.toUpperCase()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Contact'.toUpperCase()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('Total Post'.toString()),
                  size: ColumnSize.S,
                  numeric: true,
                  fixedWidth: styles.isMobile ? null : 100,
                ),
                DataColumn2(
                  label: Text('Action'.toUpperCase()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
              ],
              rows: List<DataRow>.generate(affiliations.length, (index) {
                var affi = affiliations[index];
                var affiNotice = notice
                    .where((element) => element.affliation.contains(affi.name))
                    .toList();
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),
                    DataCell(Text(affiliations[index].name, style: rowStyles)),
                    DataCell(Text(affiliations[index].secreataryName,
                        style: rowStyles)),
                    DataCell(
                        Text(affiliations[index].contact, style: rowStyles)),
                    DataCell(
                        Text(affiNotice.length.toString(), style: rowStyles)),
                    DataCell(
                      Row(
                        children: [
                          //edit
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              ref
                                  .read(editAffiliationProvider.notifier)
                                  .setAffiliation(affiliations[index]);
                              ref.read(isNewAffiliation.notifier).state = false;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              CustomDialogs.showDialog(
                                message:
                                    'Are you sure you want to delete this Affiliation?',
                                secondBtnText: 'Delete',
                                type: DialogType.warning,
                                onConfirm: () {
                                  ref
                                      .read(dashAffiliationProvider.notifier)
                                      .delete(affiliations[index], ref);
                                },
                              );
                            },
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

  final _formKey = GlobalKey<FormState>();

  Widget _buildAddAffiliation() {
    var notifier = ref.read(newAffProvider.notifier);
    var students = ref.watch(studentsProvider).list;
    var maergedList = [...students];
    var names = maergedList.map((e) => e.name).toList();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Form(
                  key: _formKey,
                  child: Wrap(runSpacing: 20, spacing: 10, children: [
                    SizedBox(
                      width: 350,
                      child: CustomTextFields(
                        hintText: 'Affiliation Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Affiliation name is required';
                          }
                          return null;
                        },
                        onSaved: (name) {
                          notifier.setName(name!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: CustomDropDown(
                        items: names
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        validator: (sec) {
                          if (sec == null) {
                            return 'Secretary is required';
                          }
                          return null;
                        },
                        onChanged: (sec) {
                          if (sec == null) return;
                          var secretary = maergedList
                              .firstWhere((element) => element.name == sec);
                          notifier.setScretary(secretary);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: CustomTextFields(
                        hintText: 'Contact',
                        isPhoneInput: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact is required';
                          } else if (value.length < 10) {
                            return 'Contact must be 10 digits';
                          }
                          return null;
                        },
                        onSaved: (contact) {
                          notifier.setContact(contact!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: CustomButton(
                        text: 'Save',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            notifier.save(ref);
                            _formKey.currentState!.reset();
                          }
                        },
                      ),
                    )
                  ]))),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(isNewAffiliation.notifier).state = false;
            },
          )
        ],
      ),
    );
  }

  final _edtFormKey = GlobalKey<FormState>();
  Widget _buildEditAffiliation() {
    var notifier = ref.read(editAffiliationProvider.notifier);
    var provider = ref.watch(editAffiliationProvider);
    var students = ref.watch(studentsProvider).list;
    var maergedList = [...students];
    var names = maergedList.map((e) => e.name).toList();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Form(
                  key: _edtFormKey,
                  child: Wrap(runSpacing: 20, spacing: 10, children: [
                    SizedBox(
                      width: 350,
                      child: CustomTextFields(
                        hintText: 'Affiliation Name',
                        initialValue: provider.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Affiliation name is required';
                          }
                          return null;
                        },
                        onSaved: (name) {
                          notifier.setName(name!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: CustomDropDown(
                        //value: provider.secreataryName.isEmpty?null:provider.secreataryName,
                        items: names
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        validator: (sec) {
                          if (sec == null) {
                            return 'Secretary is required';
                          }
                          return null;
                        },
                        onChanged: (sec) {
                          if (sec == null) return;
                          var secretary = maergedList
                              .firstWhere((element) => element.name == sec);
                          notifier.setScretary(secretary);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: CustomTextFields(
                        hintText: 'Contact',
                        initialValue: provider.contact,
                        isPhoneInput: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact is required';
                          } else if (value.length < 10) {
                            return 'Contact must be 10 digits';
                          }
                          return null;
                        },
                        onSaved: (contact) {
                          notifier.setContact(contact!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: CustomButton(
                        text: 'Update',
                        onPressed: () {
                          if (_edtFormKey.currentState!.validate()) {
                            _edtFormKey.currentState!.save();
                            notifier.save(ref);
                            _edtFormKey.currentState!.reset();
                          }
                        },
                      ),
                    )
                  ]))),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(isNewAffiliation.notifier).state = false;
              ref.read(editAffiliationProvider.notifier).reset();
            },
          )
        ],
      ),
    );
  }
}

final isNewAffiliation = StateProvider<bool>((ref) => false);
