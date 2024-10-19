import 'package:flutter/material.dart';

class MeasurementServiceModel {
  String? title;
  String? description;
  IconData? icons;

  MeasurementServiceModel({
    this.title,
    this.description,
    this.icons,
  });
}

class MeasurementServiceDummyData {
  static List<MeasurementServiceModel> dummyDataService = [
    MeasurementServiceModel(
      title: "Oil",
      description: "Oil",
      icons: Icons.oil_barrel_rounded,
    ),
    MeasurementServiceModel(
      title: "Coolant Water",
      description: "Oil",
      icons: Icons.water,
    ),
    MeasurementServiceModel(
      title: "Side Oil",
      description: "Side Oil",
      icons: Icons.oil_barrel_outlined,
    ),
    MeasurementServiceModel(
      title: "Odo",
      description: "Odo",
      icons: Icons.numbers_rounded,
    ),
    MeasurementServiceModel(
      title: "Battery",
      description: "Battery",
      icons: Icons.battery_5_bar_outlined,
    ),
  ];
}
