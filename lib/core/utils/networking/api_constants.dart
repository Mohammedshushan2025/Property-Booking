class ApiConstants {
  static const String PropertyBookingUrl =
      // 'http://41.38.186.147:7003/ords/arab_inverstors/Ascon_Inv/' ;//live
  'http://49.12.83.111:7003/ords/arab_inverstors/Ascon_Inv/' ; //test

  static const String getUser = 'emp_info/';
  static const String getAccessInfo = 'ACCESSINFO';
  static const String getAllZones = 'Get_Building_Projects_zone';
  static const String getProjectByZone = 'Get_Building_projects/';
  static const String getLandByProject = 'Get_building_Land/';
  static const String getBuildingByLand = 'Get_Building_name/';
  static const String getUnitsByBuilding = 'Get_Unit_names/';
  static const String getAllPhotosByBuilding = 'Get_AllPhoto_Buildings/';
  static const String getModelPhotoByBuilding = 'Get_Photo_Building';
  static const String getAllPhotosForUnit = 'Get_AllPhoto_UNITES';
  static const String reserveUnit = 'post_reserve_unit'; // Speculative
  static const String getCustomers = 'Ge_Customer_code_name';
}
