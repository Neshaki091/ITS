import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlateService {
  Future<Map<String, dynamic>?> uploadImageToServer(
    String serverUrl,
    File imageFile,
  ) async {
    final uri = Uri.parse(
      '$serverUrl/api/upload_plate_image',
    ); // sửa biến ở đây

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Upload failed: ${response.body}');
      return null;
    }
  }
}
