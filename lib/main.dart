import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qr_scanner_page/qr_scanner.dart';
import 'package:test_zadani/bloc/qr_code_scanner_bloc.dart';
import 'ui/contactsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCodeScannerBloc>(
      create: (context) => QrCodeScannerBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          QrViewPage.id: (context) => QrViewPage(),
          MyContacts.id: (context) => MyContacts(),
        },
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}


