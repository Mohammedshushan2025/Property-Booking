import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';

import '../../data/models/salesperson_model.dart';
import '../../mock/lead_mock_data.dart';

class SalesTrackingView extends StatefulWidget {
  final SalesPerson salesPerson;

  const SalesTrackingView({super.key, required this.salesPerson});

  @override
  State<SalesTrackingView> createState() => _SalesTrackingViewState();
}

class _SalesTrackingViewState extends State<SalesTrackingView>
    with TickerProviderStateMixin {
  late MapController _mapController;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  // Selected location from dropdown
  late Map<String, dynamic> _selectedLocation;
  late final List<Map<String, dynamic>> _dropdownLocations;

  static const Color _primary = ColorManager.primaryColor;
  static const Color _accent = ColorManager.availableColor;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _dropdownLocations = [
      {
        'label': 'الموقع الحالي',
        'lat': widget.salesPerson.latitude,
        'lng': widget.salesPerson.longitude,
      },
      ...LeadMockData.mapLocations,
    ];

    // Default to the rep's actual current location
    _selectedLocation = _dropdownLocations.first;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  ll.LatLng get _currentLatLng =>
      ll.LatLng(_selectedLocation['lat'], _selectedLocation['lng']);

  void _onLocationChanged(Map<String, dynamic>? loc) {
    if (loc == null) return;
    setState(() => _selectedLocation = loc);
    Future.microtask(() => _mapController.move(_currentLatLng, 11.0));
  }

  // ── Animated marker ──────────────────────────────────────────────────────────
  Widget _buildAnimatedMarker() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _bounceAnimation]),
      builder: (context, _) {
        return SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - _pulseAnimation.value).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.4 + _pulseAnimation.value * 0.8,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent.withValues(alpha: 0.2),
                      border: Border.all(
                        color: _accent.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primary,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    CustomPaint(
                      size: const Size(14, 8),
                      painter: _TrianglePainter(color: _primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Bottom info panel ────────────────────────────────────────────────────────
  Widget _buildInfoPanel() {
    return Container(
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rep info + LIVE badge
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: NetworkImage(widget.salesPerson.avatarUrl),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.salesPerson.name,
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // // Location dropdown
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton<Map<String, dynamic>>(
                    //     value: _selectedLocation,
                    //     isDense: true,
                    //     isExpanded: true,
                    //     dropdownColor: ColorManager.darkGrayColor,
                    //     style: TextStyle(
                    //       fontSize: 11.sp,
                    //       color: ColorManager.grayColor,
                    //     ),
                    //     icon: Icon(
                    //       Icons.keyboard_arrow_down,
                    //       color: ColorManager.availableColor,
                    //       size: 16.sp,
                    //     ),
                    //     items: _dropdownLocations
                    //         .map(
                    //           (loc) => DropdownMenuItem(
                    //             value: loc,
                    //             child: Row(
                    //               children: [
                    //                 Icon(
                    //                   loc['label'] == 'الموقع الحالي'
                    //                       ? Icons.my_location
                    //                       : Icons.location_on,
                    //                   size: 12.sp,
                    //                   color: ColorManager.availableColor,
                    //                 ),
                    //                 SizedBox(width: 4.w),
                    //                 Text(
                    //                   loc['label'] as String,
                    //                   style: TextStyle(
                    //                     fontSize: 11.sp,
                    //                     color: ColorManager.grayColor,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         )
                    //         .toList(),
                    //     onChanged: _onLocationChanged,
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Live badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'مباشر',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                'وحدات',
                '${widget.salesPerson.unitsSold}',
                Icons.home_work_outlined,
                _primary,
              ),
              _buildStat(
                'عملاء',
                '${widget.salesPerson.totalCustomers}',
                Icons.people_outline,
                const Color(0xFF6366F1),
              ),
              _buildStat(
                'إيراد',
                '${(widget.salesPerson.monthlySales / 1000000).toStringAsFixed(1)}M',
                Icons.monetization_on_outlined,
                _accent,
              ),
            ],
          ),

          // Activities
          if (widget.salesPerson.recentActivities.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(color: Colors.white12, height: 1),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'آخر الأنشطة',
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            ...widget.salesPerson.recentActivities.map(
              (a) => _buildActivityItem(a),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9.sp, color: ColorManager.grayColor),
        ),
      ],
    );
  }

  Widget _buildActivityItem(SalesActivity activity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(activity.icon, size: 14.sp, color: activity.color),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '${activity.action} · ${activity.detail}',
              style: TextStyle(fontSize: 11.sp, color: ColorManager.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(fontSize: 10.sp, color: ColorManager.grayColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.darkGrayColor,
      appBar: AppBar(
        backgroundColor: ColorManager.darkGray,
        foregroundColor: ColorManager.white,
        title: Text(
          'تتبع ${widget.salesPerson.name}',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: ColorManager.availableColor),
            tooltip: 'توسيط الخريطة',
            onPressed: () => _mapController.move(_currentLatLng, 12.0),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLatLng,
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.propertybooking',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLatLng,
                    width: 80,
                    height: 80,
                    child: _buildAnimatedMarker(),
                    alignment: Alignment.topCenter,
                  ),
                ],
              ),
            ],
          ),

          // ── Info panel ───────────────────────────────────────────────────────
          Positioned(bottom: 0, left: 0, right: 0, child: _buildInfoPanel()),
        ],
      ),
    );
  }
}

// ── Triangle painter ──────────────────────────────────────────────────────────
class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
