import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class RequestAdminScreen extends StatefulWidget {
  const RequestAdminScreen({super.key});

  @override
  State<RequestAdminScreen> createState() => _RequestAdminScreenState();
}

class _RequestAdminScreenState extends State<RequestAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<SignupProcessProvider>();
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Request Admin for approval',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Send your request to the admin for approval. We'll notify you once you're verified!",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // button
            PrimaryButton(
              onTap: provider.sendAdminForApproval,
              child: const Text(
                'Send Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              onTap: () {},
              variant: ButtonVariant.secondary,
              child: const Text(
                'Edit Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),);
  }
}
