import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Uint8List createTLV(String tag, String value) {
  Uint8List tagBytes = hexStringToBytes(tag);
  Uint8List valueBytes = Uint8List.fromList(utf8.encode(value));
  Uint8List lengthBytes = Uint8List.fromList([valueBytes.length]);
  return Uint8List.fromList([...tagBytes, ...lengthBytes, ...valueBytes]);
}

Uint8List hexStringToBytes(String hexString) {
  List<int> bytes = [];
  for (int i = 0; i < hexString.length; i += 2) {
    String hex = hexString.substring(i, i + 2);
    bytes.add(int.parse(hex, radix: 16));
  }
  return Uint8List.fromList(bytes);
}

void main() {
  // Example values from your provided builder
  String sellerName = "AMAN AND JUDEH FOUNDATION FOR PACKAGING";
  String taxNumber = "302059123900003";
  String invoiceDate = "2024-08-24 13:00:10"; // Corrected date format
  String totalAmount = "100";
  String taxAmount = "105";

  // Create TLVs for each field
  Uint8List tlv1 = createTLV("01", sellerName);
  Uint8List tlv2 = createTLV("02", taxNumber);
  Uint8List tlv3 = createTLV("03", invoiceDate);
  Uint8List tlv4 = createTLV("04", totalAmount);
  Uint8List tlv5 = createTLV("05", taxAmount);

  // Combine TLVs
  Uint8List tlvs = Uint8List.fromList([...tlv1, ...tlv2, ...tlv3, ...tlv4, ...tlv5]);

  // Encode TLVs to Base64
  String base64Text = base64.encode(tlvs);

  // Remove newline characters
  String sanitizedBase64Text = base64Text.replaceAll('\n', '');

  // Print the base64 code for verification
  print('base64 code: $sanitizedBase64Text');

  // Display the QR code
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(data: sanitizedBase64Text, version: QrVersions.auto, size: 200.0),
            SizedBox(height: 20),
            Text('Scan QR Code'),
          ],
        ),
      ),
    ),
  ));
}
