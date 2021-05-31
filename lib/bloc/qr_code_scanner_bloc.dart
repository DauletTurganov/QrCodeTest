import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
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

      // final PermissionStatus permissionStatus = await _getPermission();
      // print(permissionStatus);
      // if (permissionStatus == PermissionStatus.granted) {
      //   print(permissionStatus);
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
      // ContactsService.addContact(event.dataFromQr);
      FlutterContact.Contact cont = FlutterContact.Contact.fromVCard(event.dataFromQr);
      FlutterContact.FlutterContacts.insertContact(cont);
      final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts();
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
