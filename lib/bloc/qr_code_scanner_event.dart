part of 'qr_code_scanner_bloc.dart';

abstract class QrCodeScannerEvent extends Equatable {
  const QrCodeScannerEvent();
}

class ScanButtonClicked extends QrCodeScannerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OpenCamera extends QrCodeScannerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class QrPermissionRequest extends QrCodeScannerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class QrAddToContacts extends QrCodeScannerEvent {
  QrAddToContacts({this.data});
  String? data;
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class FetchQrCodeContact extends QrCodeScannerEvent {

  final String dataFromQr;

  FetchQrCodeContact(this.dataFromQr);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}