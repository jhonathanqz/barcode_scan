import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
          .listen(
        (barcode) => print(barcode),
      );
    } on PlatformException catch (ex) {
      setState(() {
        _scanBarcode = "Erro: $ex";
      });
    } on FormatException {
      setState(() {
        _scanBarcode = "Escaneia algo...";
      });
    } catch (e) {}
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Falha ao obter a versão da plataforma.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Falha ao obter a versão da plataforma.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Barcode scan'),
          centerTitle: true,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue[900]!,
                      ),
                    ),
                    onPressed: () => scanBarcodeNormal(),
                    child: Text('Start Scan'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue[900]!,
                      ),
                    ),
                    onPressed: () => scanQR(),
                    child: Text('Start QR scan'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue[900]!,
                      ),
                    ),
                    onPressed: () => startBarcodeScanStream(),
                    child: Text(
                      'Start barcode scan stream',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Resultado: $_scanBarcode\n',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
