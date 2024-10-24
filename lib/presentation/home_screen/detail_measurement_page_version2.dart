import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/hp2_get_list_log_bloc/hp2_get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_vehicle_page_version2.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/dvp_stats_item_widget_version2.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class DetailMeasurementPageVersion2 extends StatefulWidget {
  // final String title;
  // final VehicleDataModel data;
  // final DatumVehicle data;
  final ListDatumVehicleDataEntity data;
  // final dynamic data;
  // final CategorizedVehicleLogData data;
  final int indexMeasurement;
  final List<String>? listMeasurementTitleByGroup;

  const DetailMeasurementPageVersion2({
    Key? key,
    // required this.title,
    required this.data,
    required this.indexMeasurement,
    required this.listMeasurementTitleByGroup,
  }) : super(key: key);

  @override
  State<DetailMeasurementPageVersion2> createState() => _DetailMeasurementPageVersion2State();
}

class _DetailMeasurementPageVersion2State extends State<DetailMeasurementPageVersion2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      appBar: AppBarWidget(
        title: "${widget.data.vehicleName}: ${widget.data.measurmentTitle![widget.indexMeasurement]}",
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
            "Stats of ${widget.data.measurmentTitle![widget.indexMeasurement]}",
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
    return BlocBuilder<Hp2GetListLogBloc, Hp2GetListLogState>(
      builder: (context, state) {
        if (state is Hp2GetListLogLoading) {
          return const Center(
            child: AppLoadingIndicator(),
          );
        } else if (state is Hp2GetListLogFailed) {
          return Text(state.errorMessage);
        } else if (state is Hp2GetListLogSuccess) {
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
                      () => DetailVehiclePageVersion2(
                        // index: state.result!.listData!.indexWhere(
                        //   (element) {
                        //     return element.vehicleId == widget.data.id;
                        //   },
                        // ),
                        // indexMeasurement: widget.indexMeasurement,
                        idVehicle: widget.data.id!,
                        datumVehicle: widget.data,
                        listMeasurementTitleByGroup: widget.listMeasurementTitleByGroup,
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
                DVPStatsItemWidgetVersion2(
                  // title: "Test Title",
                  // title: state.result!.listData![widget.index].measurementTitle,
                  title: state
                      .result!
                      .listData![state.result!.listData!.indexWhere(
                    (element) {
                      return element.measurementTitle == widget.data.measurmentTitle?[widget.indexMeasurement];
                    },
                  )]
                      .measurementTitle,

                  // data: state.result!.listData![state.result!.listData!.indexWhere(
                  //   (element) {
                  //     return element.id == widget.data.id;
                  //   },
                  // )],
                  data: state.result!.listData!,
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
