import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/rounded_linear_progress_bar.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';
import 'package:provider/provider.dart';

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
              return ScalingButton(
                onTap: provider.previousPage,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.arrow_back, color: Colors.black),),
              );
            },
          ),
          title: Consumer<SignupProcessProvider>(
            builder: (context, provider, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: (provider.currentPage + 1) / provider.widgets.length,
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
                      children: provider.widgets,
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
