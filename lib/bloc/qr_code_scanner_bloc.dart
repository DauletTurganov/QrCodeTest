import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as FlutterContact;
import 'package:permission_handler/permission_handler.dart';


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
        if (await Permission.contacts.isGranted) {
          final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts(
              withProperties: true
          );
          // print(_contacts);
          FlutterContact.Contact cont = FlutterContact.Contact.fromVCard(event.dataFromQr);

          //Check if contacts already in contacts
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
        } else {
          openAppSettings();
        }
    }


    }



  Future _reqContacts() async{
    final permission = await FlutterContact.FlutterContacts.requestPermission();
    if (permission == true) {
      final List<FlutterContact.Contact> _contacts = await FlutterContact.FlutterContacts.getContacts(
          withProperties: true
      );
      return _contacts;
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
