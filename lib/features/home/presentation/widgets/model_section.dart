import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_network_image.dart';
import '../../data/models/unit_model.dart';
import '../../data/models/building_photo_model.dart';
import 'unit_card.dart';

class ModelSection extends StatefulWidget {
  final String modelName;
  final List<UnitModel> units;
  final List<BuildingPhotoModel> photos;
  final List<UnitModel> allFilteredUnits;
  final VoidCallback? onRefresh;

  const ModelSection({
    super.key,
    required this.modelName,
    required this.units,
    required this.photos,
    required this.allFilteredUnits,
    this.onRefresh,
  });

  @override
  State<ModelSection> createState() => _ModelSectionState();
}

class _ModelSectionState extends State<ModelSection> {
  bool _isExpanded = false;

  int get _availableUnits =>
      widget.units.where((unit) => unit.unitStatus?.toInt() == 0).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview Image with Gradient and Info
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            height: 200.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: widget.photos.isNotEmpty
                      ? CustomNetworkImage(
                          image: widget.photos.first.photoURL ?? '',
                          placeHolder: ImageManager.splashImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Container(
                          color: ColorManager.darkGrayColor.withValues(
                            alpha: 0.3,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60.sp,
                              color: ColorManager.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                ),

                // Gradient Overlay (darker at bottom)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // Bottom Info Row
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        // Model Info Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Model Name
                              Text(
                                widget.modelName,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.availableColor,
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
                              ),
                              SizedBox(height: 4.h),
                              // Available Units Info
                              Text(
                                '$_availableUnits متاحة من ${widget.units.length} وحدة',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: ColorManager.white.withValues(
                                    alpha: 0.9,
                                  ),
                                  fontWeight: FontWeight.w500,
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

                        // Dropdown Button
                        Container(
                          decoration: BoxDecoration(
                            color: ColorManager.availableColor.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: ColorManager.availableColor.withValues(
                                alpha: 0.4,
                              ),
                              width: 1.w,
                            ),
                          ),
                          child: IconButton(
                            icon: AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorManager.availableColor,
                                size: 28.sp,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expanded Content (Carousel + Grid)
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              // Unit Cards Grid
              if (widget.units.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                    ),
                    itemCount: widget.units.length,
                    itemBuilder: (context, index) {
                      final unit = widget.units[index];
                      // Find the absolute index in the flattened list
                      final absoluteIndex = widget.allFilteredUnits.indexOf(
                        unit,
                      );
                      return UnitCard(
                        unit: unit,
                        units: widget.allFilteredUnits,
                        index: absoluteIndex,
                        onRefresh: widget.onRefresh,
                      );
                    },
                  ),
                ),

              SizedBox(height: 16.h),
            ],
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
