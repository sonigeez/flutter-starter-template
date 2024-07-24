import 'package:flutter/material.dart';

class SignupProcessProvider with ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;
  String _name = '';
  String _phoneNumber = '';
  String _houseNumber = '';
  String _block = '';

  final TextEditingController _otpController = TextEditingController();

  int get currentPage => _currentPage;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get houseNumber => _houseNumber;
  String get block => _block;

  TextEditingController get otpController => _otpController;

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
}
