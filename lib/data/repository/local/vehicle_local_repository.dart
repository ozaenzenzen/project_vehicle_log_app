import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';

class VehicleLocalRepository {
  String vehicleDataV2 = "vehicleDataV2";

  Future<bool> removeLocalVehicleDataV2() async {
    try {
      var data = await LocalService.instance.box.read(vehicleDataV2);
      if (data != null) {
        await LocalService.instance.box.remove(vehicleDataV2);
        return true;
      } else {
        return false;
        // throw Exception("Error remove userData");
      }
    } catch (e) {
      AppLoggerCS.debugLog("[removeLocalVehicleDataV2][error] $e");
      return false;
      // throw Exception(errorMessage);
    }
  }

  Future<void> setLocalVehicleDataV2({
    required VehicleDataEntity data,
  }) async {
    try {
      await LocalService.instance.box.write(vehicleDataV2, jsonEncode(data.toJson()));
      debugPrint("[saveLocalVehicleDataV2] vehicleData saved");
    } catch (e) {
      AppLoggerCS.debugLog("[setocalVehicleDataV2][error] $e");
      rethrow;
    }
  }

  Future<VehicleDataEntity?> getLocalVehicleDataV2() async {
    try {
      var output = await LocalService.instance.box.read(vehicleDataV2);
      if (output != null) {
        VehicleDataEntity? vehicleData = VehicleDataEntity.fromJson(jsonDecode(output));
        return vehicleData;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getLocalVehicleDataV2][error] $e");
      return null;
    }
  }
}
