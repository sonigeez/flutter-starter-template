import 'package:flutter/material.dart';
import 'package:patrika_community_app/modules/onboarding/state/signup_process_provider.dart';
import 'package:patrika_community_app/modules/onboarding/widgets/country_code_picker.dart';
import 'package:patrika_community_app/utils/widgets/buttons/primary_button.dart';
import 'package:patrika_community_app/utils/widgets/input_field_widget.dart';
import 'package:provider/provider.dart';

class AddResidents extends StatefulWidget {
  const AddResidents({super.key});

  @override
  State<AddResidents> createState() => _AddResidentsState();
}

class _AddResidentsState extends State<AddResidents> {
  List<Resident> residents = [Resident()];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProcessProvider>(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Residents',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Enter the names & phone numbers of all residents in your flat to complete your profile.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: residents.length,
                  itemBuilder: (context, index) {
                    return ResidentForm(
                      resident: residents[index],
                      key: UniqueKey(),
                      index: index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
        // bottom widget
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32)
                .copyWith(bottom: 40),
            // white gradient
            decoration: BoxDecoration(
              // color: Colors.red,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.3),
                ],
                stops: const [0.0127, 0.5, 0.9, 1],
              ),
            ),
            child: PrimaryButton(
              onTap: () {
                FocusScope.of(context).unfocus();
                // move to next page
                provider.nextPage();
              },
              child: const Text(
                "Save & Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Resident {
  String name;
  String phoneNumber;

  Resident({this.name = '', this.phoneNumber = ''});
}

class ResidentForm extends StatelessWidget {
  final Resident resident;
  final int index;

  const ResidentForm({
    super.key,
    required this.resident,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resident ${index + 1}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const InputField(
            labelText: 'Full Name',
          ),
          const SizedBox(height: 20.0),
          const InputField(
            labelText: 'Phone Number (optional)',
            keyboardType: TextInputType.phone,
            prefixIcon: CountryCodePicker(),
          ),
        ],
      ),
    );
  }
}
