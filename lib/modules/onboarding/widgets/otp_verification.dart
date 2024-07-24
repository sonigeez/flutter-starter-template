import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';
import 'package:provider/provider.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatelessWidget {
  const OTPVerification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProcessProvider>();
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Colors.black54;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(2),
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: fillColor,
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Verify Your Number',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enter the OTP sent to your phone number to complete the verification and access your community.',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Pinput(
              length: 6,
              controller: provider.otpController,
              closeKeyboardWhenCompleted: true,
              animationCurve: Curves.easeOutBack,
              autofocus: true,
              keyboardType: TextInputType.number,
              defaultPinTheme: defaultPinTheme,
              errorPinTheme: PinTheme(
                height: 56,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
              focusedPinTheme: PinTheme(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                ScalingButton(
                  onTap: () {},
                  child: const Text(
                    "Didn't receive code?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Resend in 00:20
                ScalingButton(
                  onTap: () {},
                  child: const Text(
                    "Resend in 00:20",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: provider.otpController,
            builder: (context, value, child) {
              return PrimaryButton(
                onTap: provider.nextPage,
                // disabled: provider.otpController.text.length != 6,
                variant: provider.otpController.text.length != 6
                    ? ButtonVariant.disabled
                    : ButtonVariant.primary,
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
