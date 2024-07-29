import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:notice_board/router/router.dart';
import 'package:notice_board/utils/colors.dart';
import 'core/local_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initData();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'online notice board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(),
      routerConfig: MyRouter(context: context, ref: ref).router(),
    );
  }
}
