import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/features/home/widgets/appbar.dart';
import 'package:ownproject/features/home/widgets/collection_wg.dart';
import 'package:ownproject/features/home/widgets/daily_practise_card_wg.dart';
import 'package:ownproject/features/home/widgets/home_bottombar_wg.dart';
import 'package:ownproject/features/home/widgets/plus_bosganda_wg.dart';
import 'package:ownproject/features/home/widgets/recentlyUploadedSection_wg.dart';
import 'package:ownproject/features/home/widgets/streak_wg.dart';
import 'package:ownproject/features/home/widgets/weekly_proggras_wg.dart';
import '../../constants/colors.dart';
import '../../constants/text.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          r.adaptive(
            mobile: 58,
            tablet: 96,
            desktop: 104,
          ),
        ),
        child: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.background,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.wp(0.05),
              ),

              child: const HomeAppBar(),

            ),
          ),
        ),
      ),

      // ================= BODY =================
      body: Stack(
    children: [
    /// 🔽 ASOSIY CONTENT (o'zgarmaydi)
    ListView(
    padding: EdgeInsets.all(r.wp(0.052)),
    children: [
    const WeeklyProgress(),
    SizedBox(height: r.text(12)),
    const DailyPracticeCard(),
    SizedBox(height: r.text(12)),
    const CollectionsHeader(),
    SizedBox(height: r.text(12)),
    const CollectionsGrid(),
    SizedBox(height: r.text(12)),
    const RecentlyUploadedSection(),
    SizedBox(height: r.text(90)),
    ],
    ),

    /// 🔥 BANNER (USTIDA CHIQADI)
    const StreakBannerOverlay(),
    ],
    ),


      // ================= FLOATING ACTION MENU =================
      floatingActionButton: FabActionMenu(
        onScanText: () {
          debugPrint("Scan text");
        },
        onManual: () {
          debugPrint("Manual");
        },
        onMic: () {
          debugPrint("Mic");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // ================= BOTTOM BAR =================
      bottomNavigationBar: HomeBottomBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onAdd: () {
          // bu endi FAB menu ichida
        },
      ),
    );
  }
}




class CollectionsHeader extends StatelessWidget {
  const CollectionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
    SvgPicture.asset(
      'assets/icons/fill.svg',
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(
        AppColors.black,
        BlendMode.srcIn,
      )),
            SizedBox(width: r.text(6)),
            Text(
              "Your collections",
              style: AppText.cardTitleSemiBold.copyWith(
                fontSize: r.text(16),
                color: AppColors.black,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: () {
            context.goNamed('seeAll');
          },
          child: Text(
            "See all",
            style: AppText.subtitleRegular.copyWith(
              fontSize: r.text(16),
              color: AppColors.primary,
            ),
          ),
        ),

      ],
    );
  }
}
