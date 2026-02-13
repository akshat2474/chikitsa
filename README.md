# Chikitsa

Chikitsa is a rural healthcare diagnostics application developed using Flutter. It is specifically engineered to operate efficiently within low-bandwidth environments, such as 2G networks. The application facilitates the collection and transmission of patient diagnostic data and medical imagery using efficient serialization and compression techniques to ensure reliability in areas with unstable internet connectivity.

## Key Features

* **Bandwidth Optimization:** Utilizes efficient data encoding and compression to minimize payload size for rapid transmission over slow networks.
* **Resilient Image Uploads:** Implements a robust image upload service that compresses images to WebP format and splits them into manageable chunks.
* **Automatic Retries:** Features an exponential backoff retry mechanism to handle network timeouts and interruptions seamlessly.
* **Structured Data Serialization:** Uses Protocol Buffers (Protobuf) for strongly typed and efficient serialization of patient data, including demographics, vitals, and geolocation.

### Data Models

The application handles comprehensive patient health records defined via Protobuf schema, including:

* **Patient Demographics:** ID, Name, Age, Gender, Phone.
* **Vitals:** Temperature, Blood Pressure, Heart Rate.
* **Metadata:** Geolocation (Latitude/Longitude), Unix Timestamps, and Symptoms list.

### Image Processing Pipeline

1. **Compression:** Images are compressed to WebP format with a quality setting of 90 and resized to a maximum dimension of 1920px.
2. **Chunking:** Large files are split into 64KB chunks to prevent request timeouts.
3. **Transmission:** Chunks are uploaded sequentially with a session ID and file hash for integrity verification.


### Tips
**Generate Protobuf files (if necessary):**
If you modify the definitions in `lib/proto/`, regenerate the Dart code:
```bash
protoc --dart_out=grpc:lib/proto -Ilib/proto lib/proto/*.proto

```