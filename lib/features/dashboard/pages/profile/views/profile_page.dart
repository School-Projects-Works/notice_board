import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notice_board/core/views/custom_button.dart';
import 'package:notice_board/core/views/custom_input.dart';
import 'package:notice_board/features/auth/provider/user_provider.dart';

import '../../../../../core/views/custom_drop_down.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import '../../affiliations/provider/dash_affi_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    return Container(
      padding: style.largerThanMobile
          ? const EdgeInsets.all(20)
          : const EdgeInsets.all(10),
      child: style.largerThanMobile ? _buildLargeScreen() : _buildSmallScreen(),
    );
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildLargeScreen() {
    var user = ref.watch(userProvider);
    var userNotifier = ref.read(userProvider.notifier);
    var style = Styles(context);
    var affi = ref.watch(dashAffiliationProvider).list;
    var items = affi.map((e) => e.name).toList();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: style.width * .6,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      //profile image
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: ref.watch(userImageProvider) != null
                            ? MemoryImage(ref.watch(userImageProvider)!)
                            : null,
                        child: ref.watch(userImageProvider) != null
                            ? null
                            : user.image == null
                                ? const Icon(Icons.person)
                                : ImageNetwork(
                                    image: user.image!, height: 90, width: 90),
                      ),
                      const SizedBox(height: 5),
                      TextButton(
                          onPressed: () {
                            _pickImage();
                          },
                          child: const Text('Change Image')),
                      const SizedBox(height: 20),
                      Text('Role: ${user.role}'.toUpperCase(),
                          style: style.title(color: primaryColor)),
                      const SizedBox(height: 20),
                      //profile details
                      CustomTextFields(
                        hintText: 'Name',
                        initialValue: user.name,
                        onSaved: (s) {
                          userNotifier.setName(s);
                        },
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFields(
                        hintText: 'Email',
                        initialValue: user.email,
                        isReadOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFields(
                        hintText: 'Phone',
                        initialValue: user.phone,
                        onSaved: (s) {
                          userNotifier.setPhone(s);
                        },
                        isPhoneInput: true,
                        validator: (phone) {
                          if (phone == null || phone.isEmpty) {
                            return 'Phone cannot be empty';
                          } else if (phone.length < 10) {
                            return 'Phone number is too short';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Select your Affiliation',
                              style: style.subtitle()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
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
                            onChanged: (value) {
                              userNotifier.addAffiliation(value.toString());
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: user.affiliations
                                .map((aff) => Container(
                                      width: 300,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                              style: style.body(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                userNotifier.removeAff(aff);
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: 'Update Profile',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              userNotifier.updateProfile(ref);
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallScreen() {
    return const SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }

  void _pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      var bytes = await image.readAsBytes();
      ref.read(userImageProvider.notifier).state = bytes;
    }
  }
}
