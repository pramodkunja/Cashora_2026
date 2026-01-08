import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/network_service.dart';

class RequestRepository {
  final NetworkService _networkService;

  RequestRepository(this._networkService);

  Future<List<String>> getCategories() async {
    try {
      final response = await _networkService.get('/requestor/categories');
      if (response.data is List) {
        return List<String>.from(response.data);
      }
      return [];
    } catch (e) {
      // Fallback or rethrow? For now return empty or rethrow
      print("Error fetching categories: $e");
      return []; 
    }
  }

  Future<Map<String, dynamic>> submitRequest({
    required String requestType,
    required double amount,
    required String purpose,
    required String description,
    required String category,
    XFile? qrFile,
    XFile? receiptFile,
    List<XFile>? billFiles,
  }) async {
    try {
      final Map<String, dynamic> fields = {
        'request_type': requestType,
        'amount': amount,
        'purpose': purpose,
        'description': description,
        'category': category,
      };

      FormData formData = FormData.fromMap(fields);

      Future<void> addFile(String key, XFile file) async {
          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            formData.files.add(MapEntry(
              key,
              MultipartFile.fromBytes(bytes, filename: file.name),
            ));
          } else {
            formData.files.add(MapEntry(
              key,
              await MultipartFile.fromFile(file.path, filename: file.name),
            ));
          }
      }

      if (qrFile != null) await addFile('qr_file', qrFile);
      if (receiptFile != null) await addFile('receipt_file', receiptFile);
      
      if (billFiles != null && billFiles.isNotEmpty) {
        for (var file in billFiles) {
           await addFile('bill_files', file);
        }
      }

      final response = await _networkService.post(
        '/requestor/submit',
        data: formData,
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMyRequests({String? status, String? paymentStatus}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (status != null) queryParams['status'] = status;
      if (paymentStatus != null) queryParams['payment_status'] = paymentStatus;

      final response = await _networkService.get(
        '/requestor/my-requests',
        queryParameters: queryParams,
      );

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      // Log error or handle
      print("Error fetching requests: $e");
      return [];
    }
  }

  Future<void> submitClarification(int id, String remarks) async {
    try {
      await _networkService.post(
        '/requestor/respond-clarification/$id', 
        data: {
          'response_text': remarks
        }
      );
    } catch (e) {
      rethrow;
    }
  }


}
