import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/assets_manager/image_manager.dart';
import 'package:propertybooking/features/home/data/models/project_model.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import 'dart:ui';

import '../../../../core/widgets/Images/custome_image.dart';

class ProjectCard extends StatelessWidget {
  final int index;
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.index,
    required this.project,
    required this.onTap,
  });

  String _getImageUrl() {
    return 'http://49.12.83.111:7003/ords/arab_inverstors/Ascon_Inv/Get_Photo_Building?p_building_code=110101010001&model=2&doc_serial=2';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.brandBlue.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 180.h,
              width: double.infinity,
              child: CustomImage(
                image: index.isEven
                    ? ImageManager.project1Image
                    : ImageManager.project2Image,
              ),

              // child: CustomNetworkImage(
              //   image: _getImageUrl(),
              //   placeHolder: ImageManager.splashImage,
              //   fit: BoxFit.cover,
              // ),
            ),

            // Dark Overlay Gradient
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Blur Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(color: Colors.transparent),
              ),
            ),

            // Card Content
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: ColorManager.white.withValues(alpha: 0.2),
                        width: 1.5.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Project Name
                              Text(
                                project.buildingNameA ??
                                    project.buildingNameE ??
                                    AppLocalizations.of(
                                      context,
                                    )!.unknownProject,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: 4.h),

                              // Project Code
                              Text(
                                '${AppLocalizations.of(context)!.projectCode}${project.buildingCode ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: ColorManager.white.withValues(
                                    alpha: 0.9,
                                  ),
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Arrow button at bottom right
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.brandBlue.withValues(
                              alpha: 0.9,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.brandBlue.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: ColorManager.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ],
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
}
