import 'dart:convert';
import 'dart:typed_data';
import 'package:bson/bson.dart';

class BsonHelper {
  static BsonEncodingResult encodeData(Map<String, dynamic> data) {
    final bsonBinary = BsonCodec.serialize(data);
    final bsonBytes = bsonBinary.byteList;
    final bsonSize = bsonBytes.length;

    final jsonString = jsonEncode(data);
    final jsonBytes = utf8.encode(jsonString);
    final jsonSize = jsonBytes.length;

    final compressionRatio = ((jsonSize - bsonSize) / jsonSize * 100).toStringAsFixed(1);

    return BsonEncodingResult(
      bsonBytes: Uint8List.fromList(bsonBytes),
      bsonSize: bsonSize,
      jsonSize: jsonSize,
      compressionRatio: compressionRatio,
      originalData: data,
    );
  }

  static Map<String, dynamic> decodeData(Uint8List bsonBytes) {
    final decoded = BsonCodec.deserialize(BsonBinary.from(bsonBytes));
    return Map<String, dynamic>.from(decoded);
  }

  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }
}

class BsonEncodingResult {
  final Uint8List bsonBytes;
  final int bsonSize;
  final int jsonSize;
  final String compressionRatio;
  final Map<String, dynamic> originalData;

  BsonEncodingResult({
    required this.bsonBytes,
    required this.bsonSize,
    required this.jsonSize,
    required this.compressionRatio,
    required this.originalData,
  });

  int get bytesSaved => jsonSize - bsonSize;
  String get base64Encoded => base64Encode(bsonBytes);
}
