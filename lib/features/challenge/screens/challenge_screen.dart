import 'package:flutter/material.dart';
import '../../../common/utils/constants.dart';
import 'recommended_screen.dart';
import 'ongoing_screen.dart';
import 'completed_screen.dart';
import 'owner_screen.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kSecondaryColor,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: kPrimaryColor, // Màu của thanh chọn
            unselectedLabelColor: Colors.white30,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Recommended', ),
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Owner'),
            ],
          ),
          title: const Text(
            'Challenges',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            // Các nội dung hiển thị trong từng tab
            RecommendedList(),
            OngoingList(),
            CompletedList(),
            OwnerList(),
          ],
        ),
      ),
    );
  }
}


