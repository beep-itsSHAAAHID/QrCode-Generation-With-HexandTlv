import 'dart:convert';
import 'dart:typed_data';

class ZatcaFatooraDataModel {
  late String sellerName;
  late String vatRegistrationNumber;
  late String invoiceStamp;
  late num totalInvoice;
  late num totalVat;

  ZatcaFatooraDataModel({
    required this.sellerName,
    required this.vatRegistrationNumber,
    required this.invoiceStamp,
    required this.totalInvoice,
    required this.totalVat,
  });

  List<int> toBytes() {
    BytesBuilder bytesBuilder = BytesBuilder();

    // 1. Seller Name
    _addTLV(bytesBuilder, 1, utf8.encode(sellerName));

    // 2. VAT Registration Number
    _addTLV(bytesBuilder, 2, utf8.encode(vatRegistrationNumber));

    // 3. Invoice Stamp
    _addTLV(bytesBuilder, 3, utf8.encode(invoiceStamp));

    // 4. Total Invoice
    _addTLV(bytesBuilder, 4, _encodeAmountField(totalInvoice));

    // 5. Total VAT
    _addTLV(bytesBuilder, 5, _encodeAmountField(totalVat));

    return bytesBuilder.toBytes();
  }

  List<int> _encodeAmountField(num amount) {
    int amountInCents = (amount * 100).round();
    return [amountInCents >> 8, amountInCents & 0xFF];
  }

  void _addTLV(BytesBuilder bytesBuilder, int tag, List<int> value) {
    bytesBuilder.addByte(tag);
    bytesBuilder.addByte(value.length);
    bytesBuilder.add(value);
  }
}

class ZatcaFatooraController {
  ZatcaFatooraController._();

  static String generateZatcaFatooraBase64Code(ZatcaFatooraDataModel fatooraData) {
    Uint8List bytes = Uint8List.fromList(fatooraData.toBytes());
    String qrCodeBase64 = base64.encode(bytes);
    return qrCodeBase64;
  }
}

void main() {
  ZatcaFatooraDataModel fatooraData = ZatcaFatooraDataModel(
    sellerName: "Records Bobs",
    vatRegistrationNumber: "310122393500003",
    invoiceStamp: "Z15:30:00T2022-04-25",
    totalInvoice: 1000.00,
    totalVat: 150.00,
  );

  String qrCode = ZatcaFatooraController.generateZatcaFatooraBase64Code(fatooraData);
  print("Generated QR Code Base64: $qrCode");
}
