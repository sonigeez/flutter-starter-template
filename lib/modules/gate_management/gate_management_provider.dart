import 'package:flutter/foundation.dart';
import 'package:patrika_community_app/models/gate_management/gate_management.dart';
import 'package:patrika_community_app/services/key_value_service.dart';
import 'package:patrika_community_app/services/network_requester.dart';

class OtpProvider with ChangeNotifier {
  OtpModel? _otp;
  bool _isLoading = false;
  String? _error;

  OtpModel? get otp => _otp;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOtp() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await KeyValueService.getUserToken();
      final res = await NetworkRequester.shared.get(
        path: '/gate-management/otp',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        if (res.data is Map<String, dynamic>) {
          _otp = OtpModel.fromJson(res.data as Map<String, dynamic>);
        } else {
          _error = 'Invalid response format';
        }
      } else {
        _error = 'Failed to fetch OTP';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
