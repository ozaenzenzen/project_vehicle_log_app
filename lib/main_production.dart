import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/app.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/init_config.dart';

void main() async {
  EnvironmentConfig.flavor = Flavor.development;
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitConfig.init();
  runApp(const MyApp());
}