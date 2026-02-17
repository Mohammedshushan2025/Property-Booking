import 'dart:convert';
import 'dart:developer';

import 'package:propertybooking/core/utils/networking/api_constants.dart';
import 'package:propertybooking/core/utils/networking/api_service.dart';
import 'package:propertybooking/features/home/data/models/building_model.dart';
import 'package:propertybooking/features/home/data/models/building_photo_model.dart';
import 'package:propertybooking/features/home/data/models/customer_model.dart';
import 'package:propertybooking/features/home/data/models/land_model.dart';
import 'package:propertybooking/features/home/data/models/project_model.dart';
import 'package:propertybooking/features/home/data/models/unit_model.dart';
import 'package:propertybooking/features/home/data/models/unit_photo_model.dart';
import 'package:propertybooking/features/home/data/models/zone_model.dart';

class HomeDatasource {
  final ApiService apiService;

  HomeDatasource({required this.apiService});

  Future<List<ZoneModel>> getAllZones() async {
    try {
      //todo add all end points , then create model for each end point then call all the api's ensure it works then get
      //todo back to the UI and ensure it follow the current design
      // apiService.get(endPoint: endPoint);
      final response = await apiService.get(endPoint: ApiConstants.getAllZones);
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }
      final List<dynamic> items = response['items'];

      final zones = items
          .map<ZoneModel?>((item) {
            try {
              return ZoneModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<ZoneModel>()
          .toList();

      log('✅ Successfully parsed ${zones.length} out of ${items.length} zones');
      return zones;
    } catch (e) {
      log('❌ Error in getAllZones: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<List<ProjectModel>> getProjectByZone(int zoneID) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getProjectByZone,
        pathParameter: zoneID.toString(),
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final projects = items
          .map<ProjectModel?>((item) {
            try {
              return ProjectModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<ProjectModel>()
          .toList();

      log(
        '✅ Successfully parsed ${projects.length} out of ${items.length} projects',
      );
      return projects;
    } catch (e) {
      log('❌ Error in getProjectByZone: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<List<LandModel>> getLandByProject(int projectID) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getLandByProject,
        pathParameter: projectID.toString(),
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final lands = items
          .map<LandModel?>((item) {
            try {
              return LandModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<LandModel>()
          .toList();

      log('✅ Successfully parsed ${lands.length} out of ${items.length} lands');
      return lands;
    } catch (e) {
      log('❌ Error in getLandByProject: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<List<BuildingModel>> getBuildingByLand(int landID) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getBuildingByLand,
        pathParameter: landID.toString(),
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final buildings = items
          .map<BuildingModel?>((item) {
            try {
              return BuildingModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<BuildingModel>()
          .toList();

      log(
        '✅ Successfully parsed ${buildings.length} out of ${items.length} buildings',
      );
      return buildings;
    } catch (e) {
      log('❌ Error in getBuildingByLand: $e', name: 'HomeDatasource');
      return [];
    }
  }

  //UNIT_STATUS=0 متاحة      -
  // 1   محجوزه
  // 3  مباعة
  Future<List<UnitModel>> getUnitsByBuilding(int buildingID) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getUnitsByBuilding,
        pathParameter: buildingID.toString(),
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final units = items
          .map<UnitModel?>((item) {
            try {
              return UnitModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<UnitModel>()
          .toList();

      log('✅ Successfully parsed ${units.length} out of ${items.length} units');
      return units;
    } catch (e) {
      log('❌ Error in getUnitsByBuilding: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<List<BuildingPhotoModel>> getAllPhotosByBuilding(
    int buildingID,
  ) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getAllPhotosByBuilding,
        pathParameter: buildingID.toString(),
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final photos = items
          .map<BuildingPhotoModel?>((item) {
            try {
              return BuildingPhotoModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<BuildingPhotoModel>()
          .toList();

      log(
        '✅ Successfully parsed ${photos.length} out of ${items.length} photos',
      );
      return photos;
    } catch (e) {
      log('❌ Error in getAllPhotosByBuilding: $e', name: 'HomeDatasource');
      return [];
    }
  }

  String getModelPhotoByBuildingURL(
    int buildingID,
    int modelCode,
    int docSerial,
  ) {
    return "${ApiConstants.PropertyBookingUrl}${ApiConstants.getModelPhotoByBuilding}?p_building_code=$buildingID&model=$modelCode&doc_serial=$docSerial";
  }

  Future<List<UnitPhotoModel>> getAllPhotoForUnit(
    int buildingID,
    int unitCode,
  ) async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getAllPhotosForUnit,
        queryParameters: {"p_building_code": buildingID, "unit_code": unitCode},
      );
      if (response['items'] is! List) {
        log('❌ Response items is not a List', name: 'HomeDatasource');
        return [];
      }

      final List<dynamic> items = response['items'];

      final photos = items
          .map<UnitPhotoModel?>((item) {
            try {
              return UnitPhotoModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing item: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<UnitPhotoModel>()
          .toList();

      log(
        '✅ Successfully parsed ${photos.length} out of ${items.length} photos',
      );
      return photos;
    } catch (e) {
      log('❌ Error in getAllPhotosForUnit: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<List<CustomerModel>> getCustomers() async {
    try {
      final response = await apiService.get(
        endPoint: ApiConstants.getCustomers,
      );
      if (response['items'] is! List) return [];
      final List<dynamic> items = response['items'];
      return items
          .map((item) {
            try {
              return CustomerModel.fromJson(item);
            } catch (e) {
              log(
                '❌ Error parsing Customer: $e\nItem: $item',
                name: 'HomeDatasource',
              );
              return null;
            }
          })
          .whereType<CustomerModel>()
          .toList();
    } catch (e) {
      log('❌ Error in getCustomers: $e', name: 'HomeDatasource');
      return [];
    }
  }

  Future<dynamic> reserveUnit({
    required int salesCode,
    required num buildingCode,
    required String unitCode,
    required String? customerName,
    required String? selectedUser,
    required String reservationDate,
    required String contractDate,
    required String description,
    required num meterPrice,
    required num unitArea,
    required num totalPrice,
    required num paymentValue,
    required String dueDate,
    required String mobileNo,
    required String nationalId,
    required int paymentType,
  }) async {
    final Map<String, dynamic> data = {
      "trns_type_code": 103,
      "branch_code": 10,
      "customer_code": selectedUser,
      "Customer_Desc": customerName,
      "cntrct_type": 1,
      "pay_type": paymentType,
      "rsrv_date": reservationDate,
      "cntrct_date": contractDate,
      "building_code": buildingCode,
      "unit_code": unitCode,
      "meter_price": meterPrice,
      "unit_area": unitArea,
      "inst_months": 12,
      "inst_no": 12,
      "val_code": 3,
      "inst_val": paymentValue,
      "inst_date": dueDate,
      "desc_a": description.isEmpty ? "دفعة حجز" : description,
      "notes": "حجز وحدة استثمار عقاري",
      "user_code": salesCode,
      "mobile_no": mobileNo,
      "ntnl_id": nationalId,
    };

    log('--- Reservation Request ---', name: 'HomeDatasource');
    log('Data: $data', name: 'HomeDatasource');
    log('---------------------------', name: 'HomeDatasource');

    try {
      final response = await apiService.post(
        endPoint: ApiConstants.reserveUnit,
        data: data,
        headers: {},
      );
      log('✅ Reservation Response: $response', name: 'HomeDatasource');
      if (response is String) {
        // Clean the response string
        String cleanedResponse = response;

        // Remove "Content-type: application/json; charset=utf-8" prefix if present
        if (response.contains(
          'Content-type: application/json; charset=utf-8',
        )) {
          final jsonStartIndex = response.indexOf('{');
          if (jsonStartIndex != -1) {
            cleanedResponse = response.substring(jsonStartIndex);
          }
        }

        // Try to parse as JSON
        try {
          final jsonData = jsonDecode(cleanedResponse);
          return jsonData;
        } catch (e) {
          log('❌ Failed to parse cleaned response: $e', name: 'HomeDatasource');
          return {'status': 'error', 'message': 'Failed to parse response'};
        }
      }
      return response;
    } catch (e) {
      log('❌ Error in reserveUnit: $e', name: 'HomeDatasource');
      rethrow;
    }
  }
}
