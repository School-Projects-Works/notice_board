import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/auth/data/user_model.dart';

final userProvider= StateNotifierProvider<UserProvider,UserModel>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel(
    id: '',
    email: '',
    name: '',
    phone: '',
    role: '', 
  ));

  void setUser(UserModel user) {
    state = user;
  }

  void logout({required BuildContext context})async {}
}