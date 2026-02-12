import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class CompressionHelper {
  static CompressionResult compressData(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final jsonBytes = utf8.encode(jsonString);
    final jsonSize = jsonBytes.length;
    
    final gzipBytes = gzip.encode(jsonBytes);
    final compressedSize = gzipBytes.length;
    
    final compressionRatio = ((jsonSize - compressedSize) / jsonSize * 100).toStringAsFixed(1);
    
    return CompressionResult(
      compressedBytes: Uint8List.fromList(gzipBytes),
      compressedSize: compressedSize,
      originalSize: jsonSize,
      compressionRatio: compressionRatio,
      originalData: data,
    );
  }
  
  static Map<String, dynamic> decompressData(Uint8List compressedBytes) {
    final decompressedBytes = gzip.decode(compressedBytes);
    final jsonString = utf8.decode(decompressedBytes);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
  
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }
  
  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }
}

class CompressionResult {
  final Uint8List compressedBytes;
  final int compressedSize;
  final int originalSize;
  final String compressionRatio;
  final Map<String, dynamic> originalData;
  
  CompressionResult({
    required this.compressedBytes,
    required this.compressedSize,
    required this.originalSize,
    required this.compressionRatio,
    required this.originalData,
  });
  
  int get bytesSaved => originalSize - compressedSize;
  
  String get base64Encoded => base64Encode(compressedBytes);
}
