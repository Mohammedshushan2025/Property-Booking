import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import '../../data/models/salesperson_model.dart';

class SalespersonCard extends StatelessWidget {
  final SalesPerson person;
  final VoidCallback onTrackTap;

  const SalespersonCard({
    super.key,
    required this.person,
    required this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: person.isActive
              ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
              : Colors.white12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row — avatar, name, status badge
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundImage: NetworkImage(person.avatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _StatusDot(isActive: person.isActive),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12.sp,
                            color: ColorManager.availableColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            person.zone,
                            style: TextStyle(
                              color: ColorManager.grayColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isActive: person.isActive),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(color: Colors.white12, height: 1),
            SizedBox(height: 12.h),

            // Stats + track button row
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        icon: Icons.home_work_outlined,
                        value: '${person.unitsSold}',
                        label: 'وحدة',
                        color: ColorManager.availableColor,
                      ),
                      _StatChip(
                        icon: Icons.people_outline,
                        value: '${person.totalCustomers}',
                        label: 'عميل',
                        color: const Color(0xFF6366F1),
                      ),
                      _StatChip(
                        icon: Icons.monetization_on_outlined,
                        value:
                            '${(person.monthlySales / 1000000).toStringAsFixed(1)}M',
                        label: 'إيراد',
                        color: ColorManager.brandLightBlue,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: person.isActive
                      ? onTrackTap
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${person.name} غير متاح حالياً',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: ColorManager.darkGrayColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          );
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: person.isActive
                          ? ColorManager.availableColor
                          : Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 14.sp,
                          color: person.isActive
                              ? ColorManager.black
                              : ColorManager.grayColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'تتبع',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: person.isActive
                                ? ColorManager.black
                                : ColorManager.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusDot extends StatelessWidget {
  final bool isActive;
  const _StatusDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      height: 12.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF4CAF50) : ColorManager.grayColor,
        border: Border.all(color: ColorManager.darkGray, width: 2),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4CAF50).withValues(alpha: 0.15)
            : Colors.white10,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
              : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : ColorManager.grayColor,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            isActive ? 'نشط' : 'غائب',
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : ColorManager.grayColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 16.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: ColorManager.grayColor, fontSize: 9.sp),
        ),
      ],
    );
  }
}
