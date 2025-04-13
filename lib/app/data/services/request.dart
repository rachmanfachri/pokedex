import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../global/configs.dart';

Future<Map<String, dynamic>> getRequest(String endpoint) async {
  Map<String, dynamic> result = {};
  endpoint = baseUrl + endpoint;

  try {
    var response = await http.get(Uri.parse(endpoint));
    Get.printInfo(info: 'result for $endpoint: ${response.statusCode}');
    result = {"status_code": response.statusCode, "message": response.body};
  } catch (e) {
    Get.printError(info: 'Get request error: $e');
  }

  return result;
}
