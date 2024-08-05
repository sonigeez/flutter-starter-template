import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/utils/widgets/input_field_widget.dart';
import 'package:provider/provider.dart';

class AddHomeDetails extends StatelessWidget {
  const AddHomeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProcessProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add Home 🏠',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your flat no. and block to proceed further.',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              labelText: 'Flat/House No.',
              keyboardType: TextInputType.number,
              onChanged: provider.updateHouseNumber,
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Block/Wing (optional)',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelStyle: const TextStyle(color: Colors.black),
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (Set<MaterialState> states) {
                    final color = states.contains(MaterialState.focused)
                        ? Colors.black
                        : Colors.grey;
                    return TextStyle(color: color);
                  },
                ),
              ),
              onChanged: provider.updateBlock,
            ),
            const Spacer(),
            PrimaryButton(
              onTap: () {
                provider.nextPage();
                FocusScope.of(context).unfocus();
              },
              variant: provider.houseNumber.isEmpty
                  ? ButtonVariant.disabled
                  : ButtonVariant.primary,
              // disabled: provider.houseNumber.isEmpty,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },);
  }
}
