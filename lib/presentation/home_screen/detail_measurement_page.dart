import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_vehicle_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/dvp_stats_item_widget.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class DetailMeasurementPage extends StatefulWidget {
  // final String title;
  // final VehicleDataModel data;
  final DatumVehicle data;
  // final dynamic data;
  // final CategorizedVehicleLogData data;
  final int index;

  const DetailMeasurementPage({
    Key? key,
    // required this.title,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  State<DetailMeasurementPage> createState() => _DetailMeasurementPageState();
}

class _DetailMeasurementPageState extends State<DetailMeasurementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      appBar: AppBarWidget(
        title: "${widget.data.vehicleName}: ${widget.data.categorizedData![widget.index].measurementTitle}",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headView(),
            statsView(),
          ],
        ),
      ),
    );
  }

  Widget headView() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 10.h),
          Text(
            "Stats of ${widget.data.categorizedData![widget.index].measurementTitle}",
            style: AppTheme.theme.textTheme.displayLarge?.copyWith(
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Show stats from your vehicle: ${widget.data.vehicleName}",
            style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
          // SizedBox(height: 20.h),
        ],
      ),
    );
  }

  statsView() {
    return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
      builder: (context, state) {
        if (state is GetAllVehicleLoading) {
          return const AppLoadingIndicator();
        } else if (state is GetAllVehicleFailed) {
          return Text(state.errorMessage);
        } else if (state is GetAllVehicleSuccess) {
          return Container(
            padding: EdgeInsets.all(16.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Logs",
                      style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                AppMainButtonWidget(
                  onPressed: () {
                    Get.to(
                      () => DetailVehiclePage(
                        index: state.getAllVehicleDataResponseModel!.data!.indexWhere(
                          (element) {
                            return element.vehicleName == widget.data.vehicleName;
                          },
                        ),
                        datumVehicle: widget.data,
                      ),
                    );
                  },
                  text: "See vehicle logs",
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stats",
                      style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                DVPStatsItemWidget(
                  title: state
                      .getAllVehicleDataResponseModel!
                      .data![state.getAllVehicleDataResponseModel!.data!.indexWhere(
                    (element) {
                      return element.vehicleName == widget.data.vehicleName;
                    },
                  )]
                      .categorizedData![widget.index]
                      .measurementTitle,
                  data: state
                      .getAllVehicleDataResponseModel!
                      .data![state.getAllVehicleDataResponseModel!.data!.indexWhere(
                    (element) {
                      return element.vehicleName == widget.data.vehicleName;
                    },
                  )]
                      .categorizedData![widget.index],
                ),
              ],
            ),
          );
        } else {
          return const Text("data is null");
        }
      },
    );
  }
}
