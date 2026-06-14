import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import '../../mock/lead_mock_data.dart';

class ManagerHeaderWidget extends StatelessWidget {
  const ManagerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCount = LeadMockData.salesPeople
        .where((s) => s.isActive)
        .length;
    final pendingRequests = LeadMockData.unitRequests.length;
    final totalRevenue = LeadMockData.salesPeople.fold<double>(
      0,
      (sum, s) => sum + s.monthlySales,
    );

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF261D0F), // Rich dark gold
            Color(0xFF423019), // Burnished warm gold
            Color(0xFF1B150C), // Deep obsidian gold
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B150C).withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Name + avatar row
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: const NetworkImage(LeadMockData.managerAvatar),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LeadMockData.managerName,
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.availableColor.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: ColorManager.availableColor.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        LeadMockData.managerRole,
                        style: TextStyle(
                          color: ColorManager.availableColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(Icons.people_outline, '$activeCount', 'نشط'),
              _divider(),
              _statItem(
                Icons.pending_actions_outlined,
                '$pendingRequests',
                'معاينة',
              ),
              _divider(),
              _statItem(
                Icons.monetization_on_outlined,
                '${(totalRevenue / 1000000).toStringAsFixed(1)}M',
                'إيراد',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            color: ColorManager.availableColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 50.h, color: Colors.white24);
}
