import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/footer_page.dart';
import 'package:notice_board/utils/styles.dart';

import '../components/nav_bar.dart';

class ContainerPage extends ConsumerWidget {
  const ContainerPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = Styles(context);
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: NavBar()),
      body: Container(
        color: Colors.white54,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
