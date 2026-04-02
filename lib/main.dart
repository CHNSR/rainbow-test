import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MenuBloc()),
        BlocProvider(create: (context) => PrinterBloc()),
        BlocProvider(create: (context) => OrderfullBloc()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // set mouse can scroll in Listview Gridview SingleChildScrollView
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
