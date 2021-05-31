part of 'qr_code_scanner_bloc.dart';

abstract class QrCodeScannerState extends Equatable {
  const QrCodeScannerState();
}

class QrScannerInitial extends QrCodeScannerState {
  @override
  List<Object> get props => [];
}

class QrScanned extends QrCodeScannerState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class QrPermissionGranted extends QrCodeScannerState{

  QrPermissionGranted({this.contacts});

  final List<FlutterContact.Contact>? contacts;

  QrPermissionGranted copyWith({contacts}) {
    return QrPermissionGranted(
      contacts: contacts ?? this.contacts
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>  [contacts];

}
class QrPermissionDennied extends QrCodeScannerState{
  final String? error;

  QrPermissionDennied(this.error);

  @override
  // TODO: implement props
  List<Object?> get props =>  [];

}

// class QrDownLoadedContacts extends QrCodeScannerState{
//
//   final Map? contacts;
//
//   QrDownLoadedContacts(this.contacts);
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
//
// }
