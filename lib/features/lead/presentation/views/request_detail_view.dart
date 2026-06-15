import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import '../../data/models/salesperson_model.dart';
import '../../data/models/unit_request_model.dart';
import '../../mock/lead_mock_data.dart';

class RequestDetailView extends StatefulWidget {
  final UnitRequest request;

  const RequestDetailView({super.key, required this.request});

  @override
  State<RequestDetailView> createState() => _RequestDetailViewState();
}

class _RequestDetailViewState extends State<RequestDetailView> {
  SalesPerson? _selectedRep;
  bool _isConfirming = false;

  List<SalesPerson> get _activeReps =>
      LeadMockData.salesPeople.where((s) => s.isActive).toList();

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: ColorManager.darkGrayColor,
      appBar: AppBar(
        backgroundColor: ColorManager.darkGray,
        foregroundColor: ColorManager.white,
        title: Text(
          'تفاصيل الطلب',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Unit Info Card ────────────────────────────────────────────────
            _SectionCard(
              title: 'بيانات الوحدة',
              icon: Icons.home_work_outlined,
              iconColor: ColorManager.availableColor,
              child: Column(
                children: [
                  _InfoRow(
                    label: 'كود الوحدة',
                    value: widget.request.unitCode,
                    valueStyle: TextStyle(
                      color: ColorManager.availableColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _InfoRow(label: 'النوع', value: widget.request.unitType),
                  _InfoRow(label: 'المشروع', value: widget.request.projectName),
                  _InfoRow(label: 'المنطقة', value: widget.request.zone),
                  _InfoRow(
                    label: 'السعر الإجمالي',
                    value: '${formatter.format(widget.request.unitPrice)} ج.م',
                    valueStyle: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _InfoRow(
                    label: 'طريقة الدفع',
                    value: widget.request.paymentType,
                    valueStyle: TextStyle(
                      color: ColorManager.brandLightBlue,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // ── Customer Info Card ────────────────────────────────────────────
            _SectionCard(
              title: 'بيانات العميل',
              icon: Icons.person_outline,
              iconColor: const Color(0xFF6366F1),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'الاسم',
                    value: widget.request.customerName,
                    valueStyle: TextStyle(
                      color: ColorManager.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _InfoRow(
                    label: 'رقم الهاتف',
                    value: widget.request.customerPhone,
                    leadingIcon: Icons.phone_outlined,
                  ),
                  _InfoRow(
                    label: 'الرقم القومي',
                    value: widget.request.customerNationalId,
                    leadingIcon: Icons.badge_outlined,
                  ),
                  _InfoRow(
                    label: 'تاريخ الطلب',
                    value: DateFormat(
                      'dd/MM/yyyy – hh:mm a',
                    ).format(widget.request.requestDate),
                    leadingIcon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // ── Assign Rep Card ───────────────────────────────────────────────
            _SectionCard(
              title: 'تعيين مندوب',
              icon: Icons.assignment_ind_outlined,
              iconColor: ColorManager.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر مندوباً نشطاً لهذا الطلب',
                    style: TextStyle(
                      color: ColorManager.grayColor,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.darkGrayColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: _selectedRep != null
                            ? ColorManager.availableColor.withValues(alpha: 0.5)
                            : Colors.white12,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SalesPerson>(
                        value: _selectedRep,
                        isExpanded: true,
                        hint: Text(
                          'اختر المندوب ...',
                          style: TextStyle(
                            color: ColorManager.grayColor,
                            fontSize: 13.sp,
                          ),
                        ),
                        dropdownColor: ColorManager.darkGrayColor,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: ColorManager.availableColor,
                        ),
                        items: _activeReps.map((rep) {
                          return DropdownMenuItem<SalesPerson>(
                            value: rep,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14.r,
                                  backgroundImage: NetworkImage(rep.avatarUrl),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    '${rep.name} (${rep.zone})',
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedRep = v),
                      ),
                    ),
                  ),
                  if (_selectedRep != null) ...[
                    SizedBox(height: 10.h),
                    // Selected rep mini card
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: ColorManager.availableColor.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: ColorManager.availableColor.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4CAF50),
                            size: 16,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'سيتم تعيين ${_selectedRep!.name}',
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Confirm Button ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _selectedRep == null || _isConfirming
                    ? null
                    : _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.availableColor,
                  disabledBackgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: _selectedRep != null ? 4 : 0,
                  shadowColor: ColorManager.availableColor.withValues(
                    alpha: 0.4,
                  ),
                ),
                child: _isConfirming
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        'تأكيد التعيين',
                        style: TextStyle(
                          color: ColorManager.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _onConfirm() async {
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // Update in-memory mock data
    final index = LeadMockData.unitRequests.indexWhere((r) => r.id == widget.request.id);
    if (index != -1) {
      LeadMockData.unitRequests[index] = widget.request.copyWith(
        assignedSalesPersonId: _selectedRep!.id,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تعيين ${_selectedRep!.name} بنجاح ✓',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
    Navigator.pop(context, true); // true = confirmed, remove from list
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.white12, height: 1),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final IconData? leadingIcon;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 13.sp, color: ColorManager.grayColor),
            SizedBox(width: 4.w),
          ],
          Text(
            '$label: ',
            style: TextStyle(color: ColorManager.grayColor, fontSize: 12.sp),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
                  valueStyle ??
                  TextStyle(color: ColorManager.white, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}
