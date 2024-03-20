import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';



class QR_Scanner extends StatefulWidget {
  const QR_Scanner({super.key});

  @override
  State<QR_Scanner> createState() => _QR_ScannerState();
}


class _QR_ScannerState extends State<QR_Scanner> {
  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async{
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if ( res is String) {
                    result = res;
                  }
                });
              },
              child: const Text("Open Scanner")
            ),
            Text("Barcode Result: $result"),
          ],
        ),
      )
    );
  }
}