import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patrika_community_app/models/gate_management/gate_management.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';

class PreApproveSuccessState extends StatelessWidget {
  const PreApproveSuccessState({required this.otp, super.key});
  final OtpModel otp;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Platform.isIOS
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.arrow_back,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your OTP is ready',
                    style: AppTextStyles.h1Light.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: const Color(0xff1E1E1E).withOpacity(0.05),
              height: 2.4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Generated',
                      style: AppTextStyles.h1Light.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "An OTP has been generated for your guest's entry. Please share this code with them so they can enter without any delays.",
                      style: AppTextStyles.body1Light.copyWith(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildOtpBoxes(),
                    const SizedBox(height: 40),
                    _buildValidityInfo(),
                    const Spacer(),
                    PrimaryButton(
                      onTap: () {
                        // Implement share functionality
                      },
                      child: const Text(
                        'Share OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: otp.otp.split('').map((digit) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xff1E1E1E).withOpacity(0.05),
              ),
            ),
            child: Center(
              child: Text(
                digit,
                style: AppTextStyles.body2Light.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValidityInfo() {
    final formattedDate =
        DateFormat('d MMMM, h:mm a').format(otp.expiresAt.toLocal());
    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF6F5FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xff1E1E1E).withOpacity(0.05),
          ),
        ),
        child: Text.rich(
          TextSpan(
            text: 'Valid till: ',
            style: AppTextStyles.body3Light.copyWith(fontSize: 16),
            children: [
              TextSpan(
                text: formattedDate,
                style: AppTextStyles.body3Light.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
