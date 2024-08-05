import 'package:flutter/material.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/country_code_picker.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/utils/widgets/input_field_widget.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  String getHeaderText() {
    if (F.appFlavor == Flavor.patrika_support) {
      return 'Enter your details';
    }
    return 'Create Your Resident Profile';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProcessProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getHeaderText(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Fill in your details to join your community. Let’s get you started!',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.grey,
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
              maxLength: 10,
              onChanged: provider.updatePhoneNumber,
            ),
            const Spacer(),
            Consumer<SignupProcessProvider>(
              builder: (context, provider, child) {
                return PrimaryButton(
                  variant:
                      provider.name.isEmpty || provider.phoneNumber.length != 10
                          ? ButtonVariant.disabled
                          : ButtonVariant.primary,
                  isLoading: provider.isLoading,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    provider.getOtp();
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
