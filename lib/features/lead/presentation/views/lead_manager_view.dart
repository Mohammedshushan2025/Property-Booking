import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';
import '../../data/models/unit_request_model.dart';
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
  int _requestsSubTab = 0;
  late List<UnitRequest> _requests;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      if (_requestsSubTab == 0) {
        _requests = LeadMockData.unitRequests
            .where(
              (r) => r.assignedSalesPersonId == null && r.status == 'pending',
            )
            .toList();
      } else {
        _requests = LeadMockData.unitRequests
            .where((r) => r.status == 'completed')
            .toList();
      }
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
    final totalCount = _requests.isEmpty ? 2 : _requests.length + 1;
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 20.h),
      sliver: SliverList.builder(
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            // ── Sub-tabs Header ──
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: ColorManager.darkGray.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _requestsSubTab = 0;
                            _loadRequests();
                          });
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _requestsSubTab == 0
                                ? ColorManager.availableColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'قيد الانتظار',
                            style: TextStyle(
                              color: _requestsSubTab == 0
                                  ? Colors.black
                                  : ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _requestsSubTab = 1;
                            _loadRequests();
                          });
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _requestsSubTab == 1
                                ? ColorManager.availableColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'معاينات مكتملة',
                            style: TextStyle(
                              color: _requestsSubTab == 1
                                  ? Colors.black
                                  : ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // If requests list is empty, show empty state
          if (_requests.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 60.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _requestsSubTab == 0
                          ? Icons.hourglass_empty
                          : Icons.check_circle_outline,
                      size: 60.sp,
                      color: _requestsSubTab == 0
                          ? ColorManager.availableColor
                          : const Color(0xFF4CAF50),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _requestsSubTab == 0
                          ? 'لا توجد طلبات معلقة بانتظار التعيين'
                          : 'لا توجد معاينات مكتملة حالياً',
                      style: TextStyle(
                        color: ColorManager.grayColor,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Render Request Card
          final request = _requests[index - 1];
          return RequestCard(
            request: request,
            onTap: () async {
              final confirmed = await Navigator.pushNamed(
                context,
                RouterPath.requestDetailView,
                arguments: request,
              );
              if (confirmed == true) {
                _loadRequests();
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
