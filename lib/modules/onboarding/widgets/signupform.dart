import 'package:flutter/material.dart';

import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/input_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/country_code_picker.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProcessProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Create Your Resident Profile',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Fill in your details to join your community. Let’s get you started!',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              labelText: 'Full Name',
              onChanged: provider.updateName,
            ),
            const SizedBox(height: 20),
            InputField(
              labelText: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: const CountryCodePicker(),
              onChanged: provider.updatePhoneNumber,
            ),
            const Spacer(),
            Consumer<SignupProcessProvider>(
              builder: (context, provider, child) {
                return PrimaryButton(
                  // disabled:
                  //     provider.name.isEmpty || provider.phoneNumber.isEmpty,
                  variant: provider.name.isEmpty || provider.phoneNumber.isEmpty
                      ? ButtonVariant.disabled
                      : ButtonVariant.primary,
                  onTap: () {
                    // remove focus from otp field
                    FocusScope.of(context).unfocus();
                    provider.nextPage();
                  },
                  child: const Text(
                    'Get OTP',
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
      ),
    );
  }
}
