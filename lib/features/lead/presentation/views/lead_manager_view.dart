import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';
import '../../mock/lead_mock_data.dart';
import '../widgets/manager_header_widget.dart';
import '../widgets/salesperson_card.dart';
import '../widgets/request_card.dart';
import '../widgets/settings_tab.dart';

class LeadManagerView extends StatefulWidget {
  const LeadManagerView({super.key});

  @override
  State<LeadManagerView> createState() => _LeadManagerViewState();
}

class _LeadManagerViewState extends State<LeadManagerView> {
  int _currentTab = 0;
  late List _requests;

  @override
  void initState() {
    super.initState();
    // Copy so we can remove items
    _requests = List.from(LeadMockData.unitRequests);
  }

  void _removeRequest(String id) {
    setState(() {
      _requests.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black.withValues(alpha: 0.4),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImage(image: ImageManager.splashImage, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorManager.black.withValues(alpha: 0.4),
                    ColorManager.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),

            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: ManagerHeaderWidget()),
                _buildTabSliver(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabSliver() {
    switch (_currentTab) {
      case 0:
        return _buildTeamSliver();
      case 1:
        return _buildRequestsSliver();
      case 2:
        return const SliverToBoxAdapter(child: SettingsTab());
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  // ── Tab 0 — فريق المبيعات ────────────────────────────────────────────────────
  Widget _buildTeamSliver() {
    return SliverPadding(
      padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
      sliver: SliverList.builder(
        itemCount: LeadMockData.salesPeople.length,
        itemBuilder: (context, index) {
          final person = LeadMockData.salesPeople[index];
          return SalespersonCard(
            person: person,
            onTrackTap: () {
              Navigator.pushNamed(
                context,
                RouterPath.salesTrackingView,
                arguments: person,
              );
            },
          );
        },
      ),
    );
  }

  // ── Tab 1 — معاينة ────────────────────────────────────────────────────────────
  Widget _buildRequestsSliver() {
    if (_requests.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 60.sp,
                color: const Color(0xFF4CAF50),
              ),
              SizedBox(height: 12.h),
              Text(
                'لا توجد طلبات معلقة',
                style: TextStyle(
                  color: ColorManager.grayColor,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
      sliver: SliverList.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return RequestCard(
            request: request,
            onTap: () async {
              final confirmed = await Navigator.pushNamed(
                context,
                RouterPath.requestDetailView,
                arguments: request,
              );
              if (confirmed == true) {
                _removeRequest(request.id);
              }
            },
          );
        },
      ),
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentTab,
      onTap: (i) => setState(() => _currentTab = i),
      backgroundColor: ColorManager.darkGray,
      selectedItemColor: ColorManager.availableColor,
      unselectedItemColor: ColorManager.grayColor,
      selectedLabelStyle: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 11.sp),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'فريق المبيعات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          activeIcon: Icon(Icons.assignment),
          label: 'معاينة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'إعدادات',
        ),
      ],
    );
  }
}
