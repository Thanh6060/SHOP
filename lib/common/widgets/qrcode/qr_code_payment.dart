import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class QRPaymentPage extends StatefulWidget {
  final double? amount;
  final String? orderId;

  const QRPaymentPage({
    super.key,
    this.amount,
    this.orderId,
  });

  @override
  State<QRPaymentPage> createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage> {
  late Future<String> _qrCodeFuture;

  @override
  void initState() {
    super.initState();
    _qrCodeFuture = _fetchQRData();
  }

  Future<String> _fetchQRData() async {
    try {
      final int finalAmount = (widget.amount ?? 0).toInt();

      final response = await http.post(
        Uri.parse('https://api.vietqr.io/v2/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "accountNo": "123456789",
          "accountName": "SHOP FEDOR VON BOCK",
          "acqId": 970422,
          "amount": finalAmount,
          "addInfo": "Thanh toan don ${widget.orderId}",
          "format": "text",
          "template": "compact"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == '00' && data['data'] != null) {
          return data['data']['qrCode'];
        }
        throw Exception('VietQR báo lỗi: ${data['desc'] ?? data['code']}');
      }
      throw Exception('Lỗi kết nối Server: ${response.statusCode}');
    } catch (e) {
      debugPrint("Lỗi Fetch QR: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán đơn hàng'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _qrCodeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Text('Không có dữ liệu mã QR.');
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Quét mã để thanh toán',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: QrImageView(
                    data: snapshot.data!,
                    version: QrVersions.auto,
                    size: 250.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Số tiền cần thanh toán:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(widget.amount ?? 0).toInt()} USD',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nội dung: Thanh toan don ${widget.orderId}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}