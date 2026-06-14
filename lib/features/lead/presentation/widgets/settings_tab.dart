import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/core/providers/language_provider.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isArabic = langProvider.isArabic;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _SectionLabel(label: isArabic ? 'اللغة' : 'Language'),
          SizedBox(height: 8.h),
          _SettingsCard(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.language,
                    color: ColorManager.availableColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    isArabic ? 'العربية / English' : 'Arabic / English',
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: !isArabic,
                  onChanged: (_) => langProvider.toggleLanguage(),
                  activeThumbColor: ColorManager.availableColor,
                  activeTrackColor: ColorManager.availableColor.withValues(
                    alpha: 0.3,
                  ),
                  inactiveThumbColor: ColorManager.grayColor,
                  inactiveTrackColor: Colors.white12,
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              isArabic ? 'اللغة الحالية: العربية' : 'Current language: English',
              style: TextStyle(color: ColorManager.grayColor, fontSize: 11.sp),
            ),
          ),

          SizedBox(height: 24.h),
          _SectionLabel(label: isArabic ? 'الحساب' : 'Account'),
          SizedBox(height: 8.h),

          _SettingsCard(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: ColorManager.darkGray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    title: Text(
                      isArabic ? 'تسجيل الخروج' : 'Logout',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      isArabic
                          ? 'هل أنت متأكد من تسجيل الخروج؟'
                          : 'Are you sure you want to logout?',
                      style: TextStyle(
                        color: ColorManager.grayColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          isArabic ? 'إلغاء' : 'Cancel',
                          style: TextStyle(color: ColorManager.grayColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouterPath.loginView,
                            (route) => false,
                          );
                        },
                        child: Text(
                          isArabic ? 'تأكيد' : 'Confirm',
                          style: TextStyle(color: ColorManager.errorColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ColorManager.errorColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: ColorManager.errorColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    isArabic ? 'تسجيل الخروج' : 'Logout',
                    style: TextStyle(
                      color: ColorManager.errorColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: ColorManager.grayColor,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // Version info
          Center(
            child: Text(
              isArabic ? 'الإصدار 1.0.1' : 'Version 1.0.1',
              style: TextStyle(color: ColorManager.grayColor, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        label,
        style: TextStyle(
          color: ColorManager.grayColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}
