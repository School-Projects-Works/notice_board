import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:notice_board/core/views/custom_drop_down.dart';
import 'package:notice_board/features/dashboard/pages/affiliations/provider/dash_affi_provider.dart';
import 'package:notice_board/features/dashboard/pages/notices/views/students_notice_page.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';
import 'package:notice_board/features/notice/provider/notice_provider.dart';
import 'package:notice_board/router/router.dart';
import 'package:notice_board/router/router_items.dart';
import '../../../../../core/views/custom_button.dart';
import '../../../../../core/views/custom_dialog.dart';
import '../../../../../core/views/custom_input.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';
import '../../../../home/views/components/notice_card.dart';
import '../provider/dashboard_notice_provider.dart';

class NoticesPage extends ConsumerStatefulWidget {
  const NoticesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticesPageState();
}

class _NoticesPageState extends ConsumerState<NoticesPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var notices = ref.watch(noticeListProvider).filteredRawList.toList();
    var user = ref.watch(userProvider);
    if (user.role == 'student') {
      return const StudentsNoticePage();
    }
    if (user.role == 'secretary') {
      notices =
          notices.where((element) => element.posterId == user.id).toList();
    }
    //order post by created at
    notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notices'.toUpperCase(),
            style: styles.title(fontSize: 35, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          if (!ref.watch(isNewNotice) &&
              ref.watch(editNoticeProvider).id.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: styles.width * .5,
                  child: CustomTextFields(
                    hintText: 'Search a Secretary',
                    onChanged: (query) {
                      ref.read(noticeListProvider.notifier).searchInRaw(query);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomButton(
                  text: 'Add Notice',
                  onPressed: () {
                    ref.read(isNewNotice.notifier).state = true;
                  },
                )
              ],
            ),
          if (ref.watch(isNewNotice)) _buildAddNotice(),
          if (ref.watch(editNoticeProvider).id.isNotEmpty) _buildEditNotice(),
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
              rows: List<DataRow>.generate(notices.length, (index) {
                var notice = notices[index];
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
                                item: RouterItem.dashNoticeDetailsRoute,
                                pathPrams: {'noticeId': notice.id},
                              );
                            },
                          ),
                          if (notice.posterId == user.id)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                ref
                                    .read(editNoticeProvider.notifier)
                                    .setNotice(notice);
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
                                            .read(noticeListProvider.notifier)
                                            .updateNotice(
                                                id: notice.id,
                                                status: 'published');
                                      });
                                }
                                if (value == 'unpublish') {
                                  CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to unpublish this notice?',
                                      secondBtnText: 'Unpublish',
                                      onConfirm: () {
                                        ref
                                            .read(noticeListProvider.notifier)
                                            .updateNotice(
                                                id: notice.id,
                                                status: 'unpublished');
                                      });
                                }
                                if (value == 'delete') {
                                  CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to delete this notice?',
                                      secondBtnText: 'Delete',
                                      onConfirm: () {
                                        ref
                                            .read(noticeListProvider.notifier)
                                            .deleteNotice(notice.id);
                                      });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  if (notice.status == 'unpublished')
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
                                  if (notice.status == 'published')
                                    const PopupMenuItem(
                                      padding:
                                          EdgeInsets.only(right: 30, left: 10),
                                      value: 'unpublish',
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Unpublish'),
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

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget _buildAddNotice() {
    var affi = ref.watch(dashAffiliationProvider).list;
    var items = affi.map((e) => e.name).toList();
    items.insert(0, 'All');
    var notifier = ref.read(newNoticeProvider.notifier);
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
                      if (ref.watch(noticeImageProvider).isNotEmpty)
                        Wrap(
                          children: ref
                              .watch(noticeImageProvider)
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
                                                  noticeImageProvider.notifier)
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
                                  .watch(newNoticeProvider)
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
                              .watch(newNoticeProvider)
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
                            text: 'Publish',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (ref
                                    .watch(newNoticeProvider)
                                    .affliation
                                    .isEmpty) {
                                  CustomDialogs.toast(
                                      message: 'Add Affiliation',
                                      type: DialogType.error);
                                  return;
                                }
                                notifier.publish(ref);
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
                ref.read(isNewNotice.notifier).state = false;
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
      ref.read(noticeImageProvider.notifier).addImage(images);
    }
  }

  final TextEditingController _editController = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();
  Widget _buildEditNotice() {
    var affi = ref.watch(dashAffiliationProvider).list;
    var items = affi.map((e) => e.name).toList();
    items.insert(0, 'All');
    var notifier = ref.read(editNoticeProvider.notifier);
    var provider = ref.watch(editNoticeProvider);
    _editController.text = provider.description;
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
                        initialValue: provider.title,
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
                      if (ref.watch(noticeImageProvider).isNotEmpty)
                        Wrap(
                          children: ref
                              .watch(noticeImageProvider)
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
                                                  noticeImageProvider.notifier)
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
                        )
                      else if (provider.images.isNotEmpty)
                        Wrap(
                          children: provider.images
                              .map((e) => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 100,
                                      height: 110,
                                      padding: const EdgeInsets.all(5),
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: ImageNetwork(
                                        image: e,
                                        width: 100,
                                        height: 100,
                                        fitAndroidIos: BoxFit.fill,
                                        fitWeb: BoxFitWeb.fill,
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
                        controller: _editController,
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
                        controller: _editController,
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
                                  .watch(editNoticeProvider)
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
                              .watch(editNoticeProvider)
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
                            text: 'Update',
                            onPressed: () {
                              if (_editFormKey.currentState!.validate()) {
                                _editFormKey.currentState!.save();
                                if (ref
                                    .watch(editNoticeProvider)
                                    .affliation
                                    .isEmpty) {
                                  CustomDialogs.toast(
                                      message: 'Add Affiliation',
                                      type: DialogType.error);
                                  return;
                                }
                                notifier.updateNotice(ref);
                                _editFormKey.currentState!.reset();
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
                ref.read(editNoticeProvider.notifier).removeNotice();
              },
            )
          ],
        ),
      ),
    );
  }

  }

final isNewNotice = StateProvider<bool>((ref) => false);

