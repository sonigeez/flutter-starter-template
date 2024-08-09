import 'dart:io';

import 'package:flutter/material.dart';
import 'package:patrika_community_app/services/key_value_service.dart';
import 'package:patrika_community_app/services/network_requester.dart';

import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class PreApproveGuardScreen extends StatefulWidget {
  const PreApproveGuardScreen({super.key});

  @override
  State<PreApproveGuardScreen> createState() => _PreApproveGuardScreenState();
}

enum PreApproveGuardScreenState { initial, otpVerified, otpError }

class _PreApproveGuardScreenState extends State<PreApproveGuardScreen> {
  // controller
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  PreApproveGuardScreenState state = PreApproveGuardScreenState.initial;

  Future<void> verifyOtp() async {
    print('verify otp');
    isLoading = true;
    setState(() {});
    print(_otpController.text);
    final token = await KeyValueService.getUserToken();
    final res = await NetworkRequester.shared.post(
      path: '/gate-management/pre-approval',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        'otp': _otpController.text,
      },
    );
    if (res.statusCode == 200) {
      state = PreApproveGuardScreenState.otpVerified;
      setState(() {});
    } else {
      state = PreApproveGuardScreenState.otpError;
      // show error toast
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        title: const Text('OTP is invalid or expired'),
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PatrikaBackButton(),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (context) {
                      var text = 'Back to Home';
                      if (state == PreApproveGuardScreenState.initial) {
                        text = 'Enter OTP';
                      }
                      return Text(
                        text,
                        style: AppTextStyles.h1Light.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Divider(
                color: const Color(0xff1E1E1E).withOpacity(0.05),
                height: 2.4,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Builder(
                    builder: (context) {
                      if (state == PreApproveGuardScreenState.otpVerified) {
                        return const OtpVerifiedScreen();
                      } else if (state == PreApproveGuardScreenState.otpError) {
                        return const OtpErrorScreen();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pre-Approved Entry',
                            style: AppTextStyles.h1Light.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please enter the OTP provided by the guest. This OTP was shared earlier by the resident for pre-approved entry.',
                            style: AppTextStyles.body1Light.copyWith(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: Pinput(
                              length: 6,
                              controller: _otpController,
                              enabled: !isLoading,

                              animationCurve: Curves.easeOutBack,
                              autofocus: true,
                              // defaultPinTheme: defaultPinTheme,
                              errorPinTheme: PinTheme(
                                height: 56,
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                ),
                              ),
                              onCompleted: (_) {
                                verifyOtp();
                              },
                              focusedPinTheme: PinTheme(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Spacer(),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _otpController,
                            builder: (context, value, child) {
                              return PrimaryButton(
                                onTap: verifyOtp,
                                isLoading: isLoading,
                                variant: value.text.length != 6
                                    ? ButtonVariant.disabled
                                    : ButtonVariant.primary,
                                child: const Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerifiedScreen extends StatelessWidget {
  const OtpVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Otp Verified'),
    );
  }
}

class OtpErrorScreen extends StatelessWidget {
  const OtpErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Otp is invalid or expired'),
    );
  }
}

class PatrikaBackButton extends StatelessWidget {
  const PatrikaBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ScalingButton(
      scaleFactor: 0.98,
      onTap: () {
        AppRouter.router.pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Icon(
          Platform.isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back,
        ),
      ),
    );
  }
}
