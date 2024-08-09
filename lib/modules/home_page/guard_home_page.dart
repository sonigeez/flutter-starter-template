import 'package:flutter/material.dart';
import 'package:patrika_community_app/services/key_value_service.dart';
import 'package:patrika_community_app/services/network_requester.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/helpers/generate_random_light_colors.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';

class GuardHomePage extends StatefulWidget {
  const GuardHomePage({super.key});

  @override
  State<GuardHomePage> createState() => _GuardHomePageState();
}

class _GuardHomePageState extends State<GuardHomePage> {
  final List<Entries> entries = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchEntries() async {
    final token = await KeyValueService.getUserToken();
    final res = await NetworkRequester.shared.get(
      path: '/gate-management/entries',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      final entriesData = res.data as List<dynamic>;

      setState(() {
        entries.clear(); // Clear existing entries
        entries.addAll(entriesData
            .map((e) => Entries.fromJson(e as Map<String, dynamic>)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20).copyWith(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mayflower Apartments',
                        style: AppTextStyles.body2Light,
                      ),
                      Text('Bangalore', style: AppTextStyles.smallText1Light),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: generateRandomLightColor(),
                    child: const Text('M'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // two big buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // button
                  Expanded(
                    child: ScalingButton(
                      scaleFactor: 0.9999,
                      onTap: () {
                        print('clicked');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 92,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Text(
                                'Add New Resident',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: ScalingButton(
                      scaleFactor: 0.9999,
                      onTap: () async {
                        await AppRouter.router.push(AppRoutes.preApproveGuard);
                        fetchEntries();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 92,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Text(
                                'Entry with OTP',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Center(
                child: ScalingButton(
                  onTap: fetchEntries,
                  child: Text(
                    'Fetch Entries',
                    style: AppTextStyles.body2Light.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // show all entries in table

              Expanded(
                child: entries.isEmpty
                    ? Center(child: Text('No entries to display'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Resident ID')),
                              DataColumn(label: Text('Entry Time')),
                              DataColumn(label: Text('OTP Used')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: entries.map((entry) {
                              return DataRow(cells: [
                                DataCell(Text(entry.id.toString())),
                                DataCell(Text(entry.resident_id.toString())),
                                DataCell(Text(entry.entry_time)),
                                DataCell(Text(entry.otp_used)),
                                DataCell(Text(entry.status)),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Entries {
  Entries({
    required this.id,
    required this.resident_id,
    required this.entry_time,
    required this.otp_used,
    required this.entry_by,
    required this.exit_time,
    required this.purpose,
    required this.notes,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  Entries.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int
            ? json['id'] as int
            : int.tryParse(json['id'].toString()) ?? 0,
        resident_id = json['resident_id'] is int
            ? json['resident_id'] as int
            : int.tryParse(json['resident_id'].toString()) ?? 0,
        entry_time = json['entry_time']?.toString() ?? '',
        otp_used = json['otp_used']?.toString() ?? '',
        entry_by = json['entry_by'] is int
            ? json['entry_by'] as int
            : int.tryParse(json['entry_by'].toString()) ?? 0,
        exit_time = json['exit_time']?.toString() ?? '',
        purpose = json['purpose']?.toString() ?? '',
        notes = json['notes']?.toString() ?? '',
        status = json['status']?.toString() ?? '',
        created_at = json['created_at']?.toString() ?? '',
        updated_at = json['updated_at']?.toString() ?? '';

  final int id;
  final int resident_id;
  final String entry_time;
  final String otp_used;
  final int entry_by;
  final String exit_time;
  final String purpose;
  final String notes;
  final String status;
  final String created_at;
  final String updated_at;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['resident_id'] = resident_id;
    data['entry_time'] = entry_time;
    data['otp_used'] = otp_used;
    data['entry_by'] = entry_by;
    data['exit_time'] = exit_time;
    data['purpose'] = purpose;
    data['notes'] = notes;
    data['status'] = status;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    return data;
  }
}
