part of 'qr_code_scanner_bloc.dart';

abstract class QrCodeScannerEvent extends Equatable {
  const QrCodeScannerEvent();
}

class QrPermissionRequest extends QrCodeScannerEvent {
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
