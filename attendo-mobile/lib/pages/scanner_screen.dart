import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  final String name, classId, enrollNo;
  const ScannerScreen(
      {Key? key,
      required this.name,
      required this.classId,
      required this.enrollNo})
      : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _buildQrView(context),
        (result != null)
            ? Positioned(
                bottom: 10,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.black54,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue[100],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(28, 79, 156, 1),
                      ),
                    ),
                  ),
                ),
              )
            : Column(),
      ],
    )
        //_buildQrView(context) :
        );
  }

  void check() {}

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      // print(result);
      if (result != null) {
        var snapshot =
            await _firestore.collection('classes').doc(widget.classId).get();
        if (snapshot.exists) {
          var data = snapshot.data()!;
          // print(data);
          // print(data['attendees']);
          // print(data[result]);
          if (data["attendees"] != null &&
              data['attendees'][result!.code] != null) {
            if (data["attendees"][result!.code]["used"] == false) {
              await _firestore
                  .collection("classes")
                  .doc(widget.classId)
                  .update({
                'attendees.${scanData.code}': {
                  "used": true,
                  "studentName": widget.name,
                  "studentEnr": widget.enrollNo,
                  "markedOn": Timestamp.now(),
                }
              });

              Fluttertoast.showToast(msg: "Attendance marked successfully");
              if (mounted) Navigator.of(context).pop();
            }
          } else {
            Fluttertoast.showToast(msg: "Invalid QR Code");
          }
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
