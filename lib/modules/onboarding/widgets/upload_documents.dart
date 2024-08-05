import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';
import 'package:provider/provider.dart';

class UploadDocuments extends StatelessWidget {
  const UploadDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProcessProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Upload your documents',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'To ensure the security and smooth management of our community, please upload the following documents:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          PhotoUploadRow(
            frontPhoto: signupProvider.frontPhoto,
            backPhoto: signupProvider.backPhoto,
            onPickFrontPhoto: signupProvider.pickFrontPhoto,
            onPickBackPhoto: signupProvider.pickBackPhoto,
          ),
          const Spacer(),
          Center(
            child: ScalingButton(
              onTap: () {},
              child: const Text(
                'Why we need this?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            onTap: signupProvider.frontPhoto == null ||
                    signupProvider.backPhoto == null
                ? null
                : signupProvider.nextPage,
            variant: signupProvider.frontPhoto == null ||
                    signupProvider.backPhoto == null
                ? ButtonVariant.disabled
                : ButtonVariant.primary,
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
  }
}

class PhotoUploadRow extends StatelessWidget {

  const PhotoUploadRow({
    required this.frontPhoto, required this.backPhoto, required this.onPickFrontPhoto, required this.onPickBackPhoto, super.key,
  });
  final XFile? frontPhoto;
  final XFile? backPhoto;
  final VoidCallback onPickFrontPhoto;
  final VoidCallback onPickBackPhoto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: onPickFrontPhoto,
            child: UploadPhotoContainer(
              photo: frontPhoto,
              placeholderText: 'Upload Front Photo',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: onPickBackPhoto,
            child: UploadPhotoContainer(
              photo: backPhoto,
              placeholderText: 'Upload Back Photo',
            ),
          ),
        ),
      ],
    );
  }
}

class UploadPhotoContainer extends StatelessWidget {

  const UploadPhotoContainer({
    required this.photo, required this.placeholderText, super.key,
  });
  final XFile? photo;
  final String placeholderText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: photo == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.arrowUpFromBracket),
                  SizedBox(height: 8),
                  Text(
                    'Upload Front Photo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '(PNG or JPG)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Image.file(
              File(photo!.path),
              height: 200,
            ),
    );
  }
}
