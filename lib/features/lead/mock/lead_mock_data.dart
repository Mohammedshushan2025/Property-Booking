import 'package:flutter/material.dart';
import '../data/models/salesperson_model.dart';
import '../data/models/unit_request_model.dart';

class LeadMockData {
  // ── Sales Representatives ────────────────────────────────────────────────────
  static final List<SalesPerson> salesPeople = [
    SalesPerson(
      id: 'SP001',
      name: 'أحمد ناصر',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      zone: 'العلمين الجديدة',
      isActive: true,
      unitsSold: 14,
      totalCustomers: 38,
      monthlySales: 4200000,
      latitude: 30.8400,
      longitude: 28.9600,
      recentActivities: [
        SalesActivity(
          icon: Icons.home_work_outlined,
          action: 'وحدة محجوزة',
          detail: 'شاليه C-07',
          time: '10:30 ص',
          color: const Color(0xFF4CAF50),
        ),
        SalesActivity(
          icon: Icons.people_outline,
          action: 'زيارة عميل',
          detail: 'كريم محمود',
          time: '09:45 ص',
          color: const Color(0xFF6366F1),
        ),
        SalesActivity(
          icon: Icons.attach_money,
          action: 'عقد موقّع',
          detail: 'فيلا A-03',
          time: '09:00 ص',
          color: const Color(0xFFE9AE4A),
        ),
      ],
    ),
    SalesPerson(
      id: 'SP002',
      name: 'محمد فتحي',
      avatarUrl: 'https://i.pravatar.cc/150?img=56',
      zone: 'رأس الحكمة',
      isActive: true,
      unitsSold: 11,
      totalCustomers: 31,
      monthlySales: 3100000,
      latitude: 31.0836,
      longitude: 27.7281,
      recentActivities: [
        SalesActivity(
          icon: Icons.attach_money,
          action: 'عقد موقّع',
          detail: 'شاليه D-22',
          time: '10:45 ص',
          color: const Color(0xFFE9AE4A),
        ),
        SalesActivity(
          icon: Icons.home_work_outlined,
          action: 'وحدة محجوزة',
          detail: 'فيلا B-09',
          time: '09:00 ص',
          color: const Color(0xFF4CAF50),
        ),
        SalesActivity(
          icon: Icons.people_outline,
          action: 'زيارة عميل',
          detail: 'هالة إبراهيم',
          time: '08:30 ص',
          color: const Color(0xFF6366F1),
        ),
      ],
    ),

    SalesPerson(
      id: 'SP003',
      name: 'سارة خليل',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      zone: 'عين السخنة',
      isActive: true,
      unitsSold: 9,
      totalCustomers: 22,
      monthlySales: 2750000,
      latitude: 29.5800,
      longitude: 32.3100,
      recentActivities: [
        SalesActivity(
          icon: Icons.home_work_outlined,
          action: 'وحدة محجوزة',
          detail: 'شقة B-14',
          time: '11:00 ص',
          color: const Color(0xFF4CAF50),
        ),
        SalesActivity(
          icon: Icons.call_outlined,
          action: 'مكالمة عميل',
          detail: 'منى السيد',
          time: '10:15 ص',
          color: const Color(0xFF34418C),
        ),
        SalesActivity(
          icon: Icons.people_outline,
          action: 'زيارة عميل',
          detail: 'طارق علي',
          time: '09:30 ص',
          color: const Color(0xFF6366F1),
        ),
      ],
    ),
    SalesPerson(
      id: 'SP004',
      name: 'ليلى إبراهيم',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      zone: 'مارينا الساحل الشمالي',
      isActive: false,
      unitsSold: 6,
      totalCustomers: 18,
      monthlySales: 1800000,
      latitude: 30.9830,
      longitude: 29.6850,
      recentActivities: [],
    ),
    SalesPerson(
      id: 'SP005',
      name: 'شريف محمد',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      zone: 'الغردقة',
      isActive: false,
      unitsSold: 3,
      totalCustomers: 9,
      monthlySales: 950000,
      latitude: 27.2579,
      longitude: 33.8116,
      recentActivities: [],
    ),
  ];

  // ── 4 Dummy Map Locations ────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> mapLocations = [
    {'label': 'العلمين الجديدة', 'lat': 30.8753, 'lng': 28.9564},
    {'label': 'عين السخنة', 'lat': 29.5969, 'lng': 32.3488},
    {'label': 'رأس الحكمة', 'lat': 31.0836, 'lng': 27.7281},
    {'label': 'الغردقة', 'lat': 27.2579, 'lng': 33.8116},
  ];

  // ── Unit Requests (معاينة) ────────────────────────────────────────────────────
  static List<UnitRequest> unitRequests = [
    UnitRequest(
      id: 'REQ-001',
      customerName: 'كريم محمود',
      customerPhone: '01012345678',
      customerNationalId: '29901011234567',
      unitCode: 'شاليه C-07',
      unitType: 'شاليه',
      projectName: 'سيدي عبد الرحمن ريزورت',
      zone: 'العلمين الجديدة',
      unitPrice: 3200000,
      paymentType: 'تقسيط',
      requestDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    UnitRequest(
      id: 'REQ-002',
      customerName: 'منى السيد',
      customerPhone: '01023456789',
      customerNationalId: '29805152345678',
      unitCode: 'فيلا A-03',
      unitType: 'فيلا',
      projectName: 'لاجونا العين السخنة',
      zone: 'عين السخنة',
      unitPrice: 8500000,
      paymentType: 'كاش',
      requestDate: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    UnitRequest(
      id: 'REQ-003',
      customerName: 'طارق علي',
      customerPhone: '01034567890',
      customerNationalId: '29703203456789',
      unitCode: 'شقة B-14',
      unitType: 'شقة',
      projectName: 'نورث كوست هيلز',
      zone: 'رأس الحكمة',
      unitPrice: 2100000,
      paymentType: 'تقسيط',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UnitRequest(
      id: 'REQ-004',
      customerName: 'نور حسن',
      customerPhone: '01045678901',
      customerNationalId: '30001014567890',
      unitCode: 'شاليه D-22',
      unitType: 'شاليه',
      projectName: 'مارينا ريزيدنس',
      zone: 'مارينا الساحل الشمالي',
      unitPrice: 1850000,
      paymentType: 'كاش',
      requestDate: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    UnitRequest(
      id: 'REQ-005',
      customerName: 'هالة إبراهيم',
      customerPhone: '01056789012',
      customerNationalId: '29602155678901',
      unitCode: 'فيلا B-09',
      unitType: 'فيلا',
      projectName: 'صن رايز الغردقة',
      zone: 'الغردقة',
      unitPrice: 5600000,
      paymentType: 'كاش',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ── Manager info ─────────────────────────────────────────────────────────────
  static const String managerName = 'محمود السيد';
  static const String managerRole = 'مدير المبيعات';
  static const String managerAvatar = 'https://i.pravatar.cc/150?img=68';
}
