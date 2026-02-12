import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/compression_helper.dart';
import '../utils/bson_helper.dart';

class SmsService {
  static const String API_ENDPOINT = 'https://abcll.free.beeceptor.com/send-medical-data';
  
  static Future<SmsSendResult> sendWithBestCompression({
    required String phoneNumber,
    required Map<String, dynamic> data,
  }) async {
    try {
      print(' === Patient Data to Send ===');
      print(jsonEncode(data));
      
      final gzipResult = CompressionHelper.compressData(data);
      final gzipSize = gzipResult.compressedSize;
      
      final bsonResult = BsonHelper.encodeData(data);
      final bsonSize = bsonResult.bsonSize;
      
      bool useGzip = gzipSize <= bsonSize;
      final base64Data = useGzip ? gzipResult.base64Encoded : bsonResult.base64Encoded;
      final compressedSize = useGzip ? gzipSize : bsonSize;
      final originalSize = useGzip ? gzipResult.originalSize : bsonResult.jsonSize;
      final compressionRatio = useGzip ? gzipResult.compressionRatio : bsonResult.compressionRatio;
      final compressionMethod = useGzip ? 'GZIP' : 'BSON';
      
      final payload = {
        'data': base64Data,             
        'method': compressionMethod,     
        'patient_id': data['patient_id'],
      };
      
      print('=== Sending Patient Data ===');
      print('URL: $API_ENDPOINT');
      print('Patient: ${data['patient_name']} (ID: ${data['patient_id']})');
      print('Age: ${data['age']}, Gender: ${data['gender']}');
      print('Phone: ${data['phone']}');
      print('Symptoms: ${data['symptoms']}');
      print('Temperature: ${data['temperature']}°C');
      print('Heart Rate: ${data['heart_rate']} bpm');
      print('BP: ${data['blood_pressure']}');
      print('Original size: $originalSize bytes');
      print('Compressed size: $compressedSize bytes');
      print('Using: $compressionMethod compression');
      print('Optimized payload size: ${jsonEncode(payload).length} bytes');
      
      final response = await http.post(
        Uri.parse(API_ENDPOINT),
        headers: {
          'Content-Type': 'application/json',
          'X-Patient-ID': data['patient_id'].toString(),
          'X-Patient-Name': data['patient_name'].toString(),
          'X-Compression': compressionMethod,
        },
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout after 15 seconds');
        },
      );
      
      print('=== Response Received ===');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      
      final payloadString = jsonEncode(payload);
      final bytesSent = utf8.encode(payloadString).length;
      
      print('Total bytes sent over network: $bytesSent bytes');
      print('Saved vs uncompressed: ${originalSize - bytesSent} bytes (${((originalSize - bytesSent) / originalSize * 100).toStringAsFixed(1)}% reduction)');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return SmsSendResult(
          success: true,
          phoneNumber: phoneNumber,
          dataSentBytes: compressedSize,
          base64Length: base64Data.length,
          compressionRatio: compressionRatio,
          originalJsonSize: originalSize,
          base64Payload: base64Data,
          message: 'Patient data sent successfully!\n'
                   'Patient: ${data['patient_name']}\n'
                   'Sent: $bytesSent bytes (Original: $originalSize bytes)\n'
                   'Saved: ${originalSize - bytesSent} bytes',
          compressionMethod: compressionMethod,
          httpStatusCode: response.statusCode,
          serverResponse: response.body,
          bytesSentOverNetwork: bytesSent,
        );
      } else {
        return SmsSendResult(
          success: false,
          phoneNumber: phoneNumber,
          dataSentBytes: 0,
          base64Length: 0,
          compressionRatio: '0',
          originalJsonSize: 0,
          base64Payload: '',
          message: '❌ Server returned error: ${response.statusCode}',
          compressionMethod: 'None',
          httpStatusCode: response.statusCode,
          serverResponse: response.body,
          bytesSentOverNetwork: 0,
        );
      }
    } on http.ClientException catch (e) {
      print('❌ === Network Error ===');
      print('Error: $e');
      return SmsSendResult(
        success: false,
        phoneNumber: phoneNumber,
        dataSentBytes: 0,
        base64Length: 0,
        compressionRatio: '0',
        originalJsonSize: 0,
        base64Payload: '',
        message: '❌ Network error: Check your internet connection',
        compressionMethod: 'None',
        httpStatusCode: 0,
        serverResponse: e.toString(),
        bytesSentOverNetwork: 0,
      );
    } catch (e) {
      print('❌ === Unexpected Error ===');
      print('Error: $e');
      return SmsSendResult(
        success: false,
        phoneNumber: phoneNumber,
        dataSentBytes: 0,
        base64Length: 0,
        compressionRatio: '0',
        originalJsonSize: 0,
        base64Payload: '',
        message: '❌ Error: ${e.toString()}',
        compressionMethod: 'None',
        httpStatusCode: 0,
        serverResponse: e.toString(),
        bytesSentOverNetwork: 0,
      );
    }
  }
  
  static Map<String, dynamic> receiveData({
    required String base64Data,
    required String compressionMethod,
  }) {
    try {
      if (compressionMethod == 'GZIP') {
        final compressedBytes = CompressionHelper.base64ToBytes(base64Data);
        final decompressed = CompressionHelper.decompressData(compressedBytes);
        
        print('✅ Decompressed patient data:');
        print('👤 Patient: ${decompressed['patient_name']}');
        print('📞 Phone: ${decompressed['phone']}');
        print('🏥 Symptoms: ${decompressed['symptoms']}');
        
        return decompressed;
      } else if (compressionMethod == 'BSON') {
        final bsonBytes = BsonHelper.base64ToBytes(base64Data);
        final decompressed = BsonHelper.decodeData(bsonBytes);
        
        print('✅ Decompressed patient data:');
        print('👤 Patient: ${decompressed['patient_name']}');
        print('📞 Phone: ${decompressed['phone']}');
        print('🏥 Symptoms: ${decompressed['symptoms']}');
        
        return decompressed;
      } else {
        throw Exception('Unknown compression method: $compressionMethod');
      }
    } catch (e) {
      print('❌ Error decompressing data: $e');
      rethrow;
    }
  }
  
  static Map<String, dynamic> decodeFromBeeceptor({
    required Map<String, dynamic> beeceptorPayload,
  }) {
    try {
      final base64Data = beeceptorPayload['data'] as String;
      final method = beeceptorPayload['method'] as String;
      
      return receiveData(
        base64Data: base64Data,
        compressionMethod: method,
      );
    } catch (e) {
      print('❌ Error decoding from Beeceptor: $e');
      rethrow;
    }
  }
}

class SmsSendResult {
  final bool success;
  final String phoneNumber;
  final int dataSentBytes;
  final int base64Length;
  final String compressionRatio;
  final int originalJsonSize;
  final String base64Payload;
  final String message;
  final String compressionMethod;
  final int httpStatusCode;
  final String serverResponse;
  final int bytesSentOverNetwork;
  
  SmsSendResult({
    required this.success,
    required this.phoneNumber,
    required this.dataSentBytes,
    required this.base64Length,
    required this.compressionRatio,
    required this.originalJsonSize,
    required this.base64Payload,
    required this.message,
    required this.compressionMethod,
    required this.httpStatusCode,
    required this.serverResponse,
    required this.bytesSentOverNetwork,
  });
  
  int get bytesSaved => originalJsonSize - dataSentBytes;
}
