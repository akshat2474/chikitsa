import '../utils/compression_helper.dart';
import '../utils/bson_helper.dart';

class SmsService {
  static const String SMS_API_URL = 'https://api.example.com/send-sms';
  
  static Future<SmsSendResult> sendWithBestCompression({
    required String phoneNumber,
    required Map<String, dynamic> data,
  }) async {
    try {
      final gzipResult = CompressionHelper.compressData(data);
      final gzipSize = gzipResult.compressedSize;
      
      final bsonResult = BsonHelper.encodeData(data);
      final bsonSize = bsonResult.bsonSize;
      
      if (gzipSize <= bsonSize) {
        final base64Data = gzipResult.base64Encoded;
        return SmsSendResult(
          success: true,
          phoneNumber: phoneNumber,
          dataSentBytes: gzipResult.compressedSize,
          base64Length: base64Data.length,
          compressionRatio: gzipResult.compressionRatio,
          originalJsonSize: gzipResult.originalSize,
          base64Payload: base64Data,
          message: 'GZIP compression selected',
          compressionMethod: 'GZIP',
        );
      } else {
        final base64Data = bsonResult.base64Encoded;
        return SmsSendResult(
          success: true,
          phoneNumber: phoneNumber,
          dataSentBytes: bsonResult.bsonSize,
          base64Length: base64Data.length,
          compressionRatio: bsonResult.compressionRatio,
          originalJsonSize: bsonResult.jsonSize,
          base64Payload: base64Data,
          message: 'BSON compression selected',
          compressionMethod: 'BSON',
        );
      }
    } catch (e) {
      return SmsSendResult(
        success: false,
        phoneNumber: phoneNumber,
        dataSentBytes: 0,
        base64Length: 0,
        compressionRatio: '0',
        originalJsonSize: 0,
        base64Payload: '',
        message: 'Error: $e',
        compressionMethod: 'None',
      );
    }
  }
  
  static Future<SmsSendResult> sendCompressedViaSms({
    required String phoneNumber,
    required Map<String, dynamic> data,
  }) async {
    try {
      final compressionResult = CompressionHelper.compressData(data);
      final base64Data = compressionResult.base64Encoded;
      
      return SmsSendResult(
        success: true,
        phoneNumber: phoneNumber,
        dataSentBytes: compressionResult.compressedSize,
        base64Length: base64Data.length,
        compressionRatio: compressionResult.compressionRatio,
        originalJsonSize: compressionResult.originalSize,
        base64Payload: base64Data,
        message: 'Compressed data ready for transmission',
        compressionMethod: 'GZIP',
      );
    } catch (e) {
      return SmsSendResult(
        success: false,
        phoneNumber: phoneNumber,
        dataSentBytes: 0,
        base64Length: 0,
        compressionRatio: '0',
        originalJsonSize: 0,
        base64Payload: '',
        message: 'Error: $e',
        compressionMethod: 'None',
      );
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
  });
  
  int get bytesSaved => originalJsonSize - dataSentBytes;
}
