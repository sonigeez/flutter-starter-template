// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/add_home_details.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/add_resident.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/otp_verification.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/request_admin.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/signupform.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/upload_documents.dart';
import 'package:patrika_community_app/services/key_value_service.dart';
import 'package:patrika_community_app/services/network_requester.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:toastification/toastification.dart';

class SignupProcessProvider with ChangeNotifier {
  final PageController pageController = PageController();
  final NetworkRequester _networkRequester = NetworkRequester.shared;
  int _currentPage = 0;
  String _name = '';
  String _phoneNumber = '';
  String _houseNumber = '';
  String _block = '';

  XFile? _frontPhoto;
  XFile? _backPhoto;

  final ImagePicker _picker = ImagePicker();

  final widgets = const [
    SignupForm(),
    OTPVerification(),
    UploadDocuments(),
    AddHomeDetails(),
    AddResidents(),
    RequestAdminScreen(),
  ];

  final TextEditingController _otpController = TextEditingController();

  int get currentPage => _currentPage;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get houseNumber => _houseNumber;
  String get block => _block;

  XFile? get frontPhoto => _frontPhoto;
  XFile? get backPhoto => _backPhoto;

  TextEditingController get otpController => _otpController;

  bool _isLoading = false;
  bool _signupFailed = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get signupFailed => _signupFailed;
  String get errorMessage => _errorMessage;
  final String _unAuthText =
      'You are not authorized to use this app. Please contact the admin.';

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSignupFailed(bool failed, [String? message]) {
    _signupFailed = failed;
    _errorMessage = message ?? '';
    notifyListeners();
  }

  Future<void> getOtp() async {
    final isSupportApp = F.appFlavor == Flavor.patrika_support;
    _setLoading(true);
    _setSignupFailed(false);
    final path = '/auth/request-otp?is_support_app=$isSupportApp';
    final body = {
      'name': _name,
      'phone_number': _phoneNumber.replaceAll('+91', ''),
    };
    const headers = {'Content-Type': 'application/json'};
    try {
      final res = await _networkRequester.post(
        path: path,
        body: body,
        headers: headers,
      );
      if (res.statusCode == 200) {
        nextPage();
      } else if (res.statusCode! >= 400) {
        _setSignupFailed(
          true,
          (res.data is Map<String, dynamic>
                  ? (res.data as Map<String, dynamic>)['message'] as String?
                  : null) ??
              _unAuthText,
        );
        // show toast
        toastification.show(
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
          title: Text(_errorMessage),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          animationDuration: const Duration(milliseconds: 300),
          animationBuilder: (context, animation, alignment, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          primaryColor: Colors.red,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 16,
              offset: Offset(0, 16),
            ),
          ],
          closeButtonShowType: CloseButtonShowType.onHover,
          closeOnClick: false,
          pauseOnHover: true,
          dragToClose: true,
        );
      } else {
        _setSignupFailed(true, 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      _setSignupFailed(true, 'An error occurred. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> verifyOtp() async {
  //   const path = '/auth/verify-otp';
  //   final body = {
  //     "phone_number": _phoneNumber.replaceAll("+91", ''),
  //     "otp": _otpController.text
  //   };
  //   const headers = {"Content-Type": "application/json"};
  //   var res = await _networkRequester.post(
  //     path: path,
  //     body: body,
  //     headers: headers,
  //   );
  //   if (res.statusCode == 200) {
  //     nextPage();
  //     KeyValueService.setUserToken(res.data['token']);
  //   }
  // }
  void navigateToSupportHomePage() {
    AppRouter.router.go(AppRoutes.supportHome);
  }

  void navigateToAdminHomePage() {
    AppRouter.router.go(AppRoutes.adminHome);
  }

  Future<void> verifyOtp() async {
    final isSupportApp = F.appFlavor == Flavor.patrika_support;
    _setLoading(true);
    _setSignupFailed(false);
    final path = '/auth/verify-otp?is_support_app=$isSupportApp';
    final body = {
      'phone_number': _phoneNumber.replaceAll('+91', ''),
      'otp': _otpController.text,
    };
    const headers = {'Content-Type': 'application/json'};
    try {
      final res = await _networkRequester.post(
        path: path,
        body: body,
        headers: headers,
      );
      if (res.statusCode == 200) {
        final userType = res.data['user']['user_type'];
        if (isSupportApp && userType != 'resident') {
          if (userType == 'admin') {
            // go to admin home page
            navigateToAdminHomePage();
            // save token
            await KeyValueService.setUserToken(res.data['token'] as String);
            return;
          } else if (userType == 'guard') {
            // go to support home page
            navigateToSupportHomePage();
            // save token
            await KeyValueService.setUserToken(res.data['token'] as String);
            return;
          }
        }

        // check if user is already logged in
        if (userType == 'resident' &&
            res.data['user']['user_status'] == 'approved') {
          // go to home page
          navigateToHomePage();
          // save token
          await KeyValueService.setUserToken(res.data['token'] as String);
          return;
        }

        nextPage();
        await KeyValueService.setUserToken(res.data['token'] as String);
      } else {
        toastification.show(
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
          title: const Text('Something went wrong'),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          animationDuration: const Duration(milliseconds: 300),
          animationBuilder: (context, animation, alignment, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          primaryColor: Colors.red,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 16,
              offset: Offset(0, 16),
            ),
          ],
          closeButtonShowType: CloseButtonShowType.onHover,
          closeOnClick: false,
          pauseOnHover: true,
          dragToClose: true,
        );
        _setSignupFailed(true, 'Failed to verify OTP. Please try again.');
      }
    } catch (e) {
      _setSignupFailed(true, 'An error occurred. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  void navigateToHomePage() {
    AppRouter.router.go(AppRoutes.home);
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _currentPage--;
      notifyListeners();
    } else {
      AppRouter.router.pop();
    }
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void updateHouseNumber(String homeNumber) {
    _houseNumber = homeNumber;
    notifyListeners();
  }

  void updateBlock(String block) {
    _block = block;
    notifyListeners();
  }

  Future<void> pickFrontPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _frontPhoto = pickedFile;
    notifyListeners();
  }

  Future<void> pickBackPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _backPhoto = pickedFile;
    notifyListeners();
  }

  Future<void> sendAdminForApproval() async {
    final token = await KeyValueService.getUserToken();
    const path = '/onboarding/ask-approval';

    final res = await _networkRequester.post(
      path: path,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      AppRouter.router.go(AppRoutes.pending);
    }
  }
}
