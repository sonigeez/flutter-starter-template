import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/add_resident.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/request_admin.dart';
import 'package:patrika_community_app/utils/widgets/rounded_linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/add_home_details.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/otp_verification.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/signupform.dart';

class SignupProcess extends StatelessWidget {
  const SignupProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProcessProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Consumer<SignupProcessProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: provider.previousPage,
              );
            },
          ),
          title: Consumer<SignupProcessProvider>(
            builder: (context, provider, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: (provider.currentPage + 1) / 5,
                ),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return RoundedLinearProgressIndicator(
                    value: value,
                    color: Colors.black,
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Consumer<SignupProcessProvider>(
                  builder: (context, provider, child) {
                    return PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: provider.pageController,
                      onPageChanged: provider.setCurrentPage,
                      children: const [
                        SignupForm(),
                        OTPVerification(),
                        AddHomeDetails(),
                        AddResidents(),
                        RequestAdminScreen()
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
