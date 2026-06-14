import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import '../../data/models/unit_request_model.dart';

class RequestCard extends StatelessWidget {
  final UnitRequest request;
  final VoidCallback onTap;

  const RequestCard({super.key, required this.request, required this.onTap});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours >= 1) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inMinutes} دقيقة';
  }

  Color _paymentColor() {
    switch (request.paymentType) {
      case 'كاش':
        return const Color(0xFF4CAF50);
      case 'تقسيط':
        return ColorManager.brandLightBlue;
      default:
        return ColorManager.availableColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: ColorManager.darkGray,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Unit type icon
            Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorManager.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                _unitIcon(),
                color: ColorManager.availableColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          request.customerName,
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Payment badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: _paymentColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          request.paymentType,
                          style: TextStyle(
                            color: _paymentColor(),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '${request.unitCode} · ${request.projectName}',
                    style: TextStyle(
                      color: ColorManager.grayColor,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 12.sp,
                        color: ColorManager.availableColor,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${formatter.format(request.unitPrice)} ج.م',
                        style: TextStyle(
                          color: ColorManager.availableColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 11.sp,
                        color: ColorManager.grayColor,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        _timeAgo(request.requestDate),
                        style: TextStyle(
                          color: ColorManager.grayColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: ColorManager.grayColor,
            ),
          ],
        ),
      ),
    );
  }

  IconData _unitIcon() {
    switch (request.unitType) {
      case 'فيلا':
        return Icons.villa_outlined;
      case 'شاليه':
        return Icons.beach_access_outlined;
      default:
        return Icons.apartment_outlined;
    }
  }
}
