import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_zadani/qr_scanner_page/qr_scanner.dart';
import 'package:test_zadani/bloc/qr_code_scanner_bloc.dart';
import 'package:test_zadani/ui/contactsPage.dart';
import 'package:test_zadani/constants.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<QrCodeScannerBloc>(context).add(QrPermissionRequest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сканер QR-кода'),
        actions: [
          TextButton(onPressed: () {
            Navigator.pushNamed(context, MyContacts.id);
          }, child: Text(
            'Контакты',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),
          ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Нажмите "Сканировать чтобы сканировать QR-код"',
                style: kTextStyle.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.purple
                ),

                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Icon(Icons.qr_code,
              size: 250.0,),
            ),
            SizedBox(
              height: 60,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                textStyle: TextStyle(
                  fontSize: 22,
                ),
                padding: EdgeInsets.all(30)
              ),
                onPressed: () {
              Navigator.pushNamed(context, QrViewPage.id);
            }, child: Text(
              'Сканировать'
            )
            ),
            SizedBox(
              height: 25,
            )
          ],

        ),
      ),
    );
  }

}