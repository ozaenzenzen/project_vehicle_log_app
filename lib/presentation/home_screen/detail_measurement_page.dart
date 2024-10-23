import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/add_measurement_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_vehicle_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/dvp_stats_item_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class DetailMeasurementPage extends StatefulWidget {
  // final String title;
  // final VehicleDataModel data;
  // final DatumVehicle data;
  final ListDatumVehicleDataEntity data;
  // final dynamic data;
  // final CategorizedVehicleLogData data;
  final int indexMeasurement;
  final List<String>? listMeasurementTitleByGroup;

  const DetailMeasurementPage({
    Key? key,
    // required this.title,
    required this.data,
    required this.indexMeasurement,
    required this.listMeasurementTitleByGroup,
  }) : super(key: key);

  @override
  State<DetailMeasurementPage> createState() => _DetailMeasurementPageState();
}

class _DetailMeasurementPageState extends State<DetailMeasurementPage> {
  List<ListDatumLogEntity>? listLogVehicleData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      floatingActionButton: FloatingActionButton.extended(
        key: const Key("DMPFAB"),
        heroTag: const Key("DMPFAB"),
        onPressed: () {
          Get.to(
            () => AddMeasurementPage.continueData(
              vehicleId: widget.data.id!,
              measurementService: widget.data.measurmentTitle![widget.indexMeasurement],
              listLogVehicleData: listLogVehicleData,
            ),
          );
        },
        label: Text(
          "Add Measurement",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
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
    return BlocBuilder<GetListLogBloc, GetListLogState>(
      builder: (context, state) {
        if (state is GetListLogLoading) {
          return const Center(
            child: AppLoadingIndicator(),
          );
        } else if (state is GetListLogFailed) {
          return Text(state.errorMessage);
        } else if (state is GetListLogSuccess) {
          listLogVehicleData = state.result?.listData;
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
                DVPStatsItemWidget(
                  // title: "Test Title",
                  // title: state.result!.listData![widget.index].measurementTitle,
                  // title: (state.result == null || state.result!.listData == null || state.result!.listData!.isEmpty)
                  //     ? ""
                  //     : state
                  //         .result!
                  //         .listData![state.result!.listData!.indexWhere(
                  //         (element) {
                  //           return element.measurementTitle == widget.data.measurmentTitle?[widget.indexMeasurement];
                  //         },
                  //       )]
                  //         .measurementTitle,
                  title: widget.data.measurmentTitle?[widget.indexMeasurement],

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
