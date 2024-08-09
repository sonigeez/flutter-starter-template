import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/helpers/generate_random_light_colors.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:patrika_community_app/utils/widgets/refresh_header.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() => _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  final List<Map<String, String>> features = [
    {
      'title': 'Pre-Approve\nGuests',
      'imageUrl':
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'title': 'Amenity  \nBooking',
      'imageUrl':
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'title': 'Buy/Sell',
      'imageUrl':
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    },
  ];

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _handleOnTap(Map<String, String> feature, BuildContext context) {
    if (feature['title'] == 'Pre-Approve\nGuests') {
      context.push(AppRoutes.preApproveResident);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          header: const CustomRefreshHeader(),
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hi Meher,\nWelcome Back!',
                      style: AppTextStyles.h1Light,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: features.map((feature) {
                    return Expanded(
                      child: ScalingButton(
                        scaleFactor: 0.99,
                        onTap: () {
                          _handleOnTap(feature, context);
                        },
                        child: Container(
                          height: 162,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFCFCFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    feature['imageUrl']!,
                                    height: 20,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  feature['title']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // _buildHighlightsSection(),
              _buildCommunityPosts(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Buy/Sell',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget _buildHighlightsSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Highlights for You',
  //           style: TextStyle(
  //             // //styleName: 18/medium;
  //             color: Colors.black,
  //             fontSize: 18,
  //             fontFamily: 'SF Pro',
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.grey[100],
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text('Society Vote', style: AppTextStyles.body2Light),
  //               const Text('Vote on New Playground Equipment',
  //                   style: AppTextStyles.body3Light),
  //               const Text('We need your opinion!',
  //                   style: AppTextStyles.body3Light),
  //               const Text(
  //                   'Should we install new playground equipment in the park?',
  //                   style: AppTextStyles.body3Light),
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {},
  //                     child: const Text('More info',
  //                         style: TextStyle(color: Colors.blue)),
  //                   ),
  //                   const Spacer(),
  //                   ElevatedButton(
  //                     onPressed: () {},
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white,
  //                       foregroundColor: Colors.black,
  //                     ),
  //                     child: const Text('No'),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   ElevatedButton(
  //                     onPressed: () {},
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.black,
  //                       foregroundColor: Colors.white,
  //                     ),
  //                     child: const Text('Yes'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCommunityPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Community Posts', style: AppTextStyles.body2Light),
        ),
        _buildCommunityPost(
          'M',
          'Madhur',
          '3 hrs ago',
          'Comfortable 3-Seater Sofa!',
          'Great condition, dark grey fabric, 78"x35"x34".\n₹10,000 (negotiable). DM if interested!',
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        ),
        _buildCommunityPost(
          'S',
          'Sasha',
          '2d ago',
          'Diwali Celebration!',
          'Our Diwali event was a blast with vibrant decorations, delicious food, and joyous moments.\n\nThanks to everyone who made it special!',
          'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
          additionalImages: [
            'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
          ],
        ),
      ],
    );
  }

  Widget _buildCommunityPost(
    String avatar,
    String name,
    String time,
    String title,
    String description,
    String imageUrl, {
    List<String>? additionalImages,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                // randome background color
                backgroundColor: generateRandomLightColor(),
                child: Text(avatar),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.body2Light),
                  Text(time, style: AppTextStyles.smallText1Light),
                ],
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.body2Light),
          Text(description, style: AppTextStyles.body3Light),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (additionalImages != null && additionalImages.isNotEmpty)
            Row(
              children: [
                for (final img in additionalImages)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            Image.network(img, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
