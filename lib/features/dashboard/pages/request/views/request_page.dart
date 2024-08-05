import 'dart:typed_data';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:notice_board/core/views/custom_button.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/new_request_provider.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/request_provider.dart';
import '../../../../../core/views/custom_dialog.dart';
import '../../../../../core/views/custom_drop_down.dart';
import '../../../../../core/views/custom_input.dart';
import '../../../../../router/router.dart';
import '../../../../../router/router_items.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';
import '../../affiliations/provider/dash_affi_provider.dart';

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
    if (user.role == 'student') {
      request =
          request.where((element) => element.posterId == user.id).toList();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Request'.toUpperCase(),
                style: styles.title(fontSize: 35, color: primaryColor),
              ),
              const SizedBox(
                width: 10,
              ),
              if (user.role == 'student')
                if (styles.largerThanMobile)
                  CustomButton(
                      text: 'Create Request',
                      onPressed: () {
                        ref.read(isNewRequest.notifier).state = true;
                      })
                else
                  CustomButton(
                    onPressed: () {
                      ref.read(isNewRequest.notifier).state = true;
                    },
                    text: '',
                    icon: const Icon(
                      Icons.add,
                    ),
                  )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (ref.watch(isNewRequest)) _buildAddNotice(),
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
                            color: notice.status == 'pending'
                                ? Colors.grey
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
                                            .read(
                                                requestFilterProvider.notifier)
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
                                            .read(
                                                requestFilterProvider.notifier)
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
                                            .read(
                                                requestFilterProvider.notifier)
                                            .deleteNotice(notice.id);
                                      });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  if (user.role == 'admin' &&
                                      notice.status == 'pending')
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
                                  if (user.role == 'admin' &&
                                      notice.status == 'pending')
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
                                  if (user.role == 'admin' ||
                                      user.id == notice.posterId)
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

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget _buildAddNotice() {
    var affi = ref.watch(dashAffiliationProvider).list;
    var items = affi.map((e) => e.name).toList();
    items.insert(0, 'All');
    var notifier = ref.read(newRequestProvider.notifier);
    var style = Styles(context);
    return Container(
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      CustomTextFields(
                        label: 'Notice Title',
                        validator: (title) {
                          if (title == null || title.isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                        onSaved: (title) {
                          notifier.setTitle(title!);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton.icon(
                          onPressed: () {
                            _pickImages();
                          },
                          label: const Text('Add Image'),
                          icon: const Icon(Icons.image)),
                      const SizedBox(
                        height: 10,
                      ),
                      if (ref.watch(requestImageProvider).isNotEmpty)
                        Wrap(
                          children: ref
                              .watch(requestImageProvider)
                              .map((e) => Container(
                                    width: 100,
                                    height: 100,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                            image: MemoryImage(e),
                                            fit: BoxFit.cover)),
                                    //delete button
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          ref
                                              .read(
                                                  requestImageProvider.notifier)
                                              .removeImage(e);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(.5),
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      CustomTextFields(
                        maxLines: 5,
                        controller: _controller,
                        label: 'Notice Content',
                        validator: (content) {
                          if (content == null || content.isEmpty) {
                            return 'Content is required';
                          }
                          return null;
                        },
                        onSaved: (content) {
                          notifier.setContent(content!);
                        },
                      ),
                      MarkdownToolbar(
                        useIncludedTextField: false,
                        iconSize: 18,
                        controller: _controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomDropDown(
                          items: items
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          label: 'Select Affiliation',
                          onChanged: ref
                                  .watch(newRequestProvider)
                                  .affliation
                                  .contains('All')
                              ? null
                              : (value) {
                                  notifier.addAffiliation(value.toString());
                                },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: ref
                              .watch(newRequestProvider)
                              .affliation
                              .map((aff) => Container(
                                    width: 300,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: secondaryColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            aff,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                style.body(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              notifier.removeAff(aff);
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                            text: 'Submit',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (ref
                                    .watch(newRequestProvider)
                                    .affliation
                                    .isEmpty) {
                                  CustomDialogs.toast(
                                      message: 'Add Affiliation',
                                      type: DialogType.error);
                                  return;
                                }
                                notifier.submit(ref);
                                _controller.clear();
                                _formKey.currentState!.reset();
                              }
                            }),
                      ],
                    ),
                  ),
                )
              ],
            )),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(isNewRequest.notifier).state = false;
              },
            )
          ],
        ),
      ),
    );
  }

  void _pickImages() async {
    var image = await ImagePicker().pickMultiImage(limit: 3);
    if (image.isNotEmpty) {
      List<Uint8List> images = [];
      for (var i = 0; i < image.length; i++) {
        var bytes = await image[i].readAsBytes();
        images.add(bytes);
      }
      ref.read(requestImageProvider.notifier).addImage(images);
    }
  }
}

final isNewRequest = StateProvider<bool>((ref) => false);
