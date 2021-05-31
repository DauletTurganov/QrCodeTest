import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:test_zadani/bloc/qr_code_scanner_bloc.dart';
import 'package:test_zadani/constants.dart';


class MyContacts extends StatefulWidget {
  const MyContacts({Key? key}) : super(key: key);
  static String id = 'my_contacts';

  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<QrCodeScannerBloc>(context).add(QrPermissionRequest());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<QrCodeScannerBloc,QrCodeScannerState> (
        builder: (context, state) {
          if (state is QrScannerInitial) {
            return Text('Initial data');
          } else if ( state is QrPermissionGranted) {
            if (state.contacts != null) {
              return ListView.builder(
                itemCount: state.contacts?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, item) {
                  print(state.contacts?.length);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('${state.contacts![item].displayName}',
                            style: kTextStyle.copyWith(
                                color: Colors.black
                            ),),
                        (state.contacts![item].phones.isEmpty) ?
                            Text('') : Text('${state.contacts![item].phones.first.number}',
                          style: kTextStyle.copyWith(
                              color: Colors.black
                          ),),
                        Divider(
                          height: 5.0,
                          color: Colors.black,
                        ),
                      ],
                    );
                  });
            }
            return Text('No Contacts');

          } else if (state is QrPermissionDennied) {
            return Column(
              children: [ Text(
            '${state.error}'
            ),
              ElevatedButton(onPressed: () {
                BlocProvider.of<QrCodeScannerBloc>(context).add(QrPermissionRequest());
              }, child: Text('Запрос на доступ к контактам'))],
            );

          }
          return CircularProgressIndicator();
        }
      ),
    );


  }
}
