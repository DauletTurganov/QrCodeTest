
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_zadani/bloc/qr_code_scanner_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';


class QrViewPage extends StatefulWidget {
  static String id = 'qr_scanner_page';
  @override
  _QrViewPageState createState() => _QrViewPageState();
}


class _QrViewPageState extends State<QrViewPage> {
  Barcode? _result;
  QRViewController? _controller;
  bool _cameraToggle = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var _camera;

  _launchURL() async{
    if (_result != null) {
      var url = _result!.code;
     try {
       launch(url);
     } catch (e) {
       throw e;
     }
    }
  }

   reqPermission() async{
    var camera = await Permission.camera.request();
    if ( camera.isGranted) {
      return camera.isGranted;
    } else if ( camera.isDenied) {
      return camera.isDenied;
    } else if ( camera.isPermanentlyDenied) {
      openAppSettings();
    }
  }



  @override
  Widget build(BuildContext context) {

    var sizes = MediaQuery.of(context).size.height;
    var widths = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            _result != null ?
            Expanded(
              flex: 4,
              child: Center(
                child: AlertDialog(
                  title: const Text('Внимание'),
                  content: SingleChildScrollView(
                    child: AlertDialogWidget(result: _result),
                  ),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text(
                        'Назад'
                    )),
                    (_result!.code.contains('BEGIN:VCARD')) ? TextButton(
                      onPressed: () {
                        BlocProvider.of<QrCodeScannerBloc>(context).add(FetchQrCodeContact(_result!.code));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Добавить в контакты'
                      ),
                    ) : Text(''),

                    //Start of if
                    (_result!.code.contains('https') || _result!.code.contains('http')) ?
                    TextButton(onPressed: () {
                      _launchURL();
                      Navigator.pop(context);
                    }, child: Text(
                        'Перейти по ссылке'
                    ),) : Text('')
                  ],
                ),
              ),
            ):
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: sizes,
                        maxWidth: widths,
                    ),
                    child: Column(
                      children: [
                        Expanded(flex: 5, child: _buildQrView(context)),
                        Expanded(flex: 1,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                          onPressed: _cameraToggleFunc,
                                          child: _cameraToggle == true ? Icon(Icons.pause) : Icon(Icons.play_arrow)
                                        // Text('pause', style: TextStyle(fontSize: 20)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await _controller?.flipCamera();
                                            setState(() {});
                                          },
                                          child: FutureBuilder(
                                            future: _controller?.getCameraInfo(),
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null) {
                                                // return Text(
                                                //     'Camera facing ${describeEnum(snapshot.data!)}');
                                                return Icon(Icons.flip_camera_ios_outlined);
                                              } else {
                                                return Text('loading');
                                              }
                                            },
                                          )),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await _controller?.toggleFlash();
                                            reqPermission();
                                            setState(() {});
                                          },
                                          child: FutureBuilder(
                                            future: _controller?.getFlashStatus(),
                                            builder: (context, snapshot) {
                                              return Icon(Icons.wb_sunny_outlined);
                                            },
                                          )),

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            openAppSettings();
                                            setState(() {});
                                          },
                                          child: Icon(Icons.settings)

                                          )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  _cameraToggleFunc() async{
    if (_cameraToggle == true) {
      _cameraToggle = !_cameraToggle;
    } else if (_cameraToggle == false) {
      _cameraToggle = true;
    }

    if (_cameraToggle == false) {
      await _controller?.pauseCamera();
      setState(() {});
    } else if (_cameraToggle == true) {
      await _controller?.resumeCamera();
      setState(() {});
    }
  }


  Widget _buildQrView(BuildContext context) {
     var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,

      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this._controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _result = scanData;
        // _launchURL();
      });
    });
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    Key? key,
    required Barcode? result,
  }) : _result = result, super(key: key);

  final Barcode? _result;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children:  <Widget>[
        Text('Сканирование завершено'),
         SizedBox(
           height: 15,
         ),
         (_result!.code.contains('BEGIN:VCARD')) ?
        Text('Данные с QR-кода получены: Контакт',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent
        ),) : Text('Данные с QR-кода: ${_result!.code}',
                  style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black
                  ),),
        SizedBox(
          height: 25,
        ),
        Text('Подтвердите ваши действия'),
      ],
    );
  }
}


