import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as FlutterContact;


part 'qr_code_scanner_event.dart';
part 'qr_code_scanner_state.dart';

class QrCodeScannerBloc extends Bloc<QrCodeScannerEvent, QrCodeScannerState> {
  QrCodeScannerBloc() : super(QrScannerInitial());

  @override
  Stream<QrCodeScannerState> mapEventToState(
    QrCodeScannerEvent event,
  ) async* {
    if (event is QrPermissionRequest) {
      // print('start request from bloc');
      final permission = await FlutterContact.FlutterContacts.requestPermission();
      if (permission == true) {
        final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts(
          withProperties: true
        );

        yield QrPermissionGranted(contacts: _contacts);
      } else {
        yield QrPermissionDennied("Отказано в доступе, пожалуйста откройте доступ к своим контактам");
      }
    } if (event is FetchQrCodeContact) {
      final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts();
      // print(_contacts);
      FlutterContact.Contact cont = FlutterContact.Contact.fromVCard(event.dataFromQr);
      if (_contacts.contains(cont)) {
        yield QrPermissionGranted().copyWith(
            contacts: _contacts
        );
      } else {
        FlutterContact.FlutterContacts.insertContact(cont);
        final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts();
        yield QrPermissionGranted().copyWith(
            contacts: _contacts
        );
      }
      FlutterContact.FlutterContacts.insertContact(cont);

      yield QrPermissionGranted().copyWith(
        contacts: _contacts
      );
      
    }

    // TODO: implement mapEventToState
  }

  // Future<PermissionStatus> _getPermission() async {
  //   final PermissionStatus permission = await Permission.contacts.status;
  //   final PermissionStatus req = await Permission.contacts.request();
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //     final Map<Permission, PermissionStatus> permissionStatus =
  //     await [Permission.contacts].request();
  //     return permissionStatus[Permission.contacts] ??
  //         PermissionStatus.granted;
  //   } else {
  //     return permission;
  //   }
  // }
}
