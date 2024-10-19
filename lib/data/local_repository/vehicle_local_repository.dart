import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/model/local/vehicle_local_data_model.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/support/app_logger.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';

class VehicleLocalRepository {
  Future<bool> removeLocalVehicleData() async {
    try {
      var data = await LocalService.instance.box.read("vehicleData");
      if (data != null) {
        await LocalService.instance.box.remove("vehicleData");
        return true;
      } else {
        return false;
        // throw Exception("Error remove userData");
      }
    } catch (errorMessage) {
      return false;
      // throw Exception(errorMessage);
    }
  }

  Future<void> saveLocalVehicleData({
    required VehicleLocalDataModel data,
  }) async {
    await LocalService.instance.box.write("vehicleData", data.toJson());
    debugPrint("[saveLocalVehicleData] vehicleData saved");
  }

  Future<VehicleLocalDataModel?> getLocalVehicleData() async {
    try {
      VehicleLocalDataModel? vehicleData = VehicleLocalDataModel.fromJson(
        LocalService.instance.box.read("vehicleData"),
      );
      // ignore: unnecessary_null_comparison, unrelated_type_equality_checks
      if (vehicleData == null || vehicleData == [] || vehicleData == "") {
        return VehicleLocalDataModel();
        // throw Exception("User data is empty");
      } else {
        return vehicleData;
      }
    } catch (errorMessage) {
      return null;
    }
  }

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
      AppLogger.debugLog("[removeLocalVehicleDataV2][error] $e");
      return false;
      // throw Exception(errorMessage);
    }
  }

  Future<void> setLocalVehicleDataV2({
    required VehicleDataEntity data,
  }) async {
    try {
      await LocalService.instance.box.write(vehicleDataV2, data.toJson());
      debugPrint("[saveLocalVehicleDataV2] vehicleData saved");
    } catch (e) {
      AppLogger.debugLog("[setocalVehicleDataV2][error] $e");
      rethrow;
    }
  }

  Future<VehicleDataEntity?> getLocalVehicleDataV2() async {
    try {
      VehicleDataEntity? vehicleData = VehicleDataEntity.fromJson(
        LocalService.instance.box.read(vehicleDataV2),
      );
      // ignore: unnecessary_null_comparison, unrelated_type_equality_checks
      if (vehicleData == null || vehicleData == [] || vehicleData == "") {
        return null;
      } else {
        return vehicleData;
      }
    } catch (e) {
      AppLogger.debugLog("[getLocalVehicleDataV2][error] $e");
      rethrow;
    }
  }
}
