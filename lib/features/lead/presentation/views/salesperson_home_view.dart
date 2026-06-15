import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import '../../data/models/salesperson_model.dart';
import '../../data/models/unit_request_model.dart';
import '../../mock/lead_mock_data.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class SalespersonHomeView extends StatefulWidget {
  final SalesPerson salesPerson;

  const SalespersonHomeView({super.key, required this.salesPerson});

  @override
  State<SalespersonHomeView> createState() => _SalespersonHomeViewState();
}

class _SalespersonHomeViewState extends State<SalespersonHomeView> {
  late List<UnitRequest> _myRequests;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _myRequests = LeadMockData.unitRequests
          .where((r) => r.assignedSalesPersonId == widget.salesPerson.id)
          .toList();
    });
  }

  void _completeRequest(String id) {
    setState(() {
      // Update in-memory state
      final index = LeadMockData.unitRequests.indexWhere((r) => r.id == id);
      if (index != -1) {
        // Remove or update the assignment to signal it's done
        LeadMockData.unitRequests.removeAt(index);
      }
      _loadRequests();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم إتمام المعاينة بنجاح ونقلها للأرشيف ✓',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر إجراء الاتصال بالرقم $phoneNumber'),
          backgroundColor: ColorManager.errorColor,
        ),
      );
    }
  }

  void _openGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // Get matching location coordinates from mock locations or default
  Map<String, dynamic> _getZoneLocation(String zoneName) {
    return LeadMockData.mapLocations.firstWhere(
      (loc) => loc['label'] == zoneName,
      orElse: () => {
        'label': zoneName,
        'lat': widget.salesPerson.latitude,
        'lng': widget.salesPerson.longitude,
      },
    );
  }

  void _showMapModal(UnitRequest request) {
    final location = _getZoneLocation(request.zone);
    final latLng = ll.LatLng(location['lat'], location['lng']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: ColorManager.darkGrayColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              // Drag Indicator & Title
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'موقع المعاينة - ${request.zone}',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12),
              
              // Interactive Map
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: latLng,
                          initialZoom: 12.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.propertybooking',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: latLng,
                                width: 80,
                                height: 80,
                                child: Icon(
                                  Icons.location_on,
                                  color: ColorManager.availableColor,
                                  size: 40.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Open Google Maps floating button
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        child: FloatingActionButton.extended(
                          onPressed: () => _openGoogleMaps(latLng.latitude, latLng.longitude),
                          backgroundColor: ColorManager.brandBlue,
                          icon: const Icon(Icons.navigation, color: Colors.white),
                          label: Text(
                            'فتح في خرائط جوجل',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black.withValues(alpha: 0.4),
      appBar: _buildAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient overlay
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
          SafeArea(
            child: RefreshIndicator(
              color: ColorManager.availableColor,
              onRefresh: () async {
                _loadRequests();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header profile overview
                  SliverToBoxAdapter(child: _buildProfileCard()),
                  
                  // KPI stats
                  SliverToBoxAdapter(child: _buildKPISection()),
                  
                  // Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            color: ColorManager.availableColor,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'طلبات المعاينة المعينة لك',
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '(${_myRequests.length}) طلبات',
                            style: TextStyle(
                              color: ColorManager.grayColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Inspection requests list
                  _buildRequestsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: ColorManager.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'بوابة المندوبين',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'تسجيل الخروج',
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouterPath.loginView,
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundImage: NetworkImage(widget.salesPerson.avatarUrl),
          ),
          SizedBox(width: 14.w),
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
                SizedBox(height: 4.h),
                Text(
                  'مندوب المبيعات · منطقة ${widget.salesPerson.zone}',
                  style: TextStyle(
                    color: ColorManager.grayColor,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          // Online status switch
          Column(
            children: [
              Switch.adaptive(
                value: _isOnline,
                activeTrackColor: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                activeThumbColor: const Color(0xFF4CAF50),
                onChanged: (val) {
                  setState(() => _isOnline = val);
                },
              ),
              Text(
                _isOnline ? 'نشط الآن' : 'غير متصل',
                style: TextStyle(
                  color: _isOnline ? const Color(0xFF4CAF50) : ColorManager.grayColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPISection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorManager.darkGray,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: ColorManager.availableColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.pending_actions,
                      color: ColorManager.availableColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_myRequests.length}',
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'معاينات جارية',
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
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorManager.darkGray,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: const Color(0xFF4CAF50),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.salesPerson.unitsSold}',
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'مبيعات مكتملة',
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
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    if (_myRequests.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                size: 64.sp,
                color: Colors.white24,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد معاينات نشطة',
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'عند تعيين معاينات جديدة لك من قبل الإدارة ستظهر هنا.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorManager.grayColor,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(bottom: 24.h),
      sliver: SliverList.builder(
        itemCount: _myRequests.length,
        itemBuilder: (context, index) {
          final request = _myRequests[index];
          return _buildRequestItemCard(request);
        },
      ),
    );
  }

  Widget _buildRequestItemCard(UnitRequest request) {
    final formattedDate = DateFormat('dd/MM/yyyy · hh:mm a').format(request.requestDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.darkGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client header details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: ColorManager.brandBlue.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: ColorManager.brandLightBlue, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.customerName,
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'الرقم القومي: ${request.customerNationalId}',
                      style: TextStyle(
                        color: ColorManager.grayColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Direction/Map launch
              IconButton(
                icon: Icon(Icons.map_outlined, color: ColorManager.availableColor, size: 20.sp),
                tooltip: 'عرض الخريطة',
                onPressed: () => _showMapModal(request),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          const Divider(color: Colors.white10, height: 1),
          SizedBox(height: 12.h),
          
          // Request Details (Phone & Location Zone & Date)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(Icons.phone_iphone, 'رقم الهاتف', request.customerPhone),
              _buildDetailItem(Icons.location_on_outlined, 'المنطقة', request.zone),
            ],
          ),
          SizedBox(height: 10.h),
          _buildDetailItem(Icons.calendar_month_outlined, 'تاريخ وتوقيت المعاينة', formattedDate),
          
          SizedBox(height: 16.h),
          
          // Action Buttons: Call & Complete
          Row(
            children: [
              // Call Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makeCall(request.customerPhone),
                  icon: const Icon(Icons.phone),
                  label: const Text('اتصال بالعميل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Complete Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _completeRequest(request.id),
                  icon: const Icon(Icons.check, color: Colors.black),
                  label: const Text(
                    'تمت المعاينة',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.availableColor,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: ColorManager.grayColor),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ColorManager.grayColor,
                fontSize: 10.sp,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
