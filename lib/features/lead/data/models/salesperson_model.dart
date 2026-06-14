import 'package:flutter/material.dart';

class SalesActivity {
  final IconData icon;
  final String action;
  final String detail;
  final String time;
  final Color color;

  const SalesActivity({
    required this.icon,
    required this.action,
    required this.detail,
    required this.time,
    required this.color,
  });
}

class SalesPerson {
  final String id;
  final String name;
  final String avatarUrl;
  final String zone;
  final bool isActive;
  final int unitsSold;
  final int totalCustomers;
  final double monthlySales;
  final double latitude;
  final double longitude;
  final List<SalesActivity> recentActivities;

  const SalesPerson({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.zone,
    required this.isActive,
    required this.unitsSold,
    required this.totalCustomers,
    required this.monthlySales,
    required this.latitude,
    required this.longitude,
    required this.recentActivities,
  });
}
