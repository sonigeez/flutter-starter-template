import 'package:flutter/material.dart';
import 'package:patrika_community_app/const/resource.dart';
import 'package:patrika_community_app/modules/gate_management/gate_management_provider.dart';
import 'package:patrika_community_app/modules/gate_management/widgets/pre_approval_success.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/widgets/global_image.dart';

import 'package:provider/provider.dart';

class PreApproveResidentScreen extends StatelessWidget {
  const PreApproveResidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpProvider()..fetchOtp(),
      child: Scaffold(
        body: Consumer<OtpProvider>(
          builder: (context, otpProvider, _) {
            if (otpProvider.isLoading) {
              return const PreApproveLoadingState();
            } else if (otpProvider.error != null) {
              return PreApproveErrorState(error: otpProvider.error!);
            } else if (otpProvider.otp != null) {
              return PreApproveSuccessState(otp: otpProvider.otp!);
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}

class PreApproveErrorState extends StatelessWidget {
  const PreApproveErrorState({required this.error, super.key});
  final String error;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Error'));
  }
}

class PreApproveLoadingState extends StatefulWidget {
  const PreApproveLoadingState({
    super.key,
  });

  @override
  State<PreApproveLoadingState> createState() => _PreApproveLoadingStateState();
}

class _PreApproveLoadingStateState extends State<PreApproveLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.toDouble(), end: -1.toDouble())
                  .animate(_controller),
              child: const GlobalImage(
                R.ASSETS_ICONS_LOADING_PNG,
                height: 52,
                width: 52,
              ),
            ),
            const SizedBox(height: 16),
            //           Generating OTP...
            Text(
              'Generating OTP...',
              style: AppTextStyles.body2Light.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Please wait while we generate a secure OTP for your guest's entry. This will only take a moment.",
              style: AppTextStyles.body3Light.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
