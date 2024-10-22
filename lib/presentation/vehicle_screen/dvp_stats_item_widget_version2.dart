import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/hp2_get_list_log_bloc/hp2_get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/edit_measurement_page_version2.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_logger.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDataVersion2 {
  SalesDataVersion2(this.year, this.sales);
  final String year;
  final double sales;
}

class DVPStatsItemWidgetVersion2 extends StatefulWidget {
  final String? title;
  // final CategorizedVehicleLogData? data;
  final List<ListDatumLogEntity>? data;

  const DVPStatsItemWidgetVersion2({
    Key? key,
    required this.title,
    this.data,
  }) : super(key: key);

  @override
  State<DVPStatsItemWidgetVersion2> createState() => _DVPStatsItemWidgetVersion2State();
}

class _DVPStatsItemWidgetVersion2State extends State<DVPStatsItemWidgetVersion2> {
  TooltipBehavior? _tooltipBehavior;
  final formatter = DateFormat('dd MMMM yyyy, HH:mm');
  final formatter2 = DateFormat('dd/MM/yyyy, HH:mm');

  List<ListDatumLogEntity> newData = <ListDatumLogEntity>[];
  List<ListDatumLogEntity> newData1 = <ListDatumLogEntity>[];
  List<ListDatumLogEntity> newDataDialog = <ListDatumLogEntity>[];

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    sorting(widget.data);
  }

  RefreshController dialogRefreshController = RefreshController(initialRefresh: false);

  void sorting(List<ListDatumLogEntity>? input) {
    newData = input!;
    newData = input.where((element) {
      return element.measurementTitle == widget.title;
    }).toList();
    newData.sort((a, b) {
      return a.createdAt!.compareTo(b.createdAt!);
    });

    newData1 = input;
    newData1 = input.where((element) {
      return element.measurementTitle == widget.title;
    }).toList();
    newData1.sort((a, b) {
      return a.createdAt!.compareTo(b.createdAt!);
    });

    newDataDialog = input;
    newDataDialog = input.where((element) {
      return element.measurementTitle == widget.title;
    }).toList();
    newDataDialog.sort((a, b) {
      return b.createdAt!.compareTo(a.createdAt!);
    });
    // AppLogger.debugLog("Output: ${newDataDialog?.map((e) => AppLogger.debugLog("e0: ${e.currentOdo}}")).toList()}");
    // AppLogger.debugLog("Output: ${newData?.map((e) => AppLogger.debugLog("e1: ${e.currentOdo}}")).toList()}");
    // AppLogger.debugLog("Output: ${newData?.map((e) => AppLogger.debugLog("e: ${jsonEncode(e.toJson())}")).toList()}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title.toString(),
                style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return BlocConsumer<GetListLogBloc, GetListLogState>(
                            listener: (context, state) {
                              if (state is GetListLogSuccess) {
                                dialogRefreshController.loadComplete();
                                dialogRefreshController.refreshCompleted();
                              }
                            },
                            builder: (context, state) {
                              if (state is GetListLogSuccess) {
                                sorting(state.result?.listData);
                              }
                              return AlertDialog(
                                title: Text(
                                  'Choose your log',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xff26120F),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                scrollable: true,
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    // width: 200.w,
                                    width: double.maxFinite,
                                    height: 350.h,
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      controller: dialogRefreshController,
                                      onRefresh: () {
                                        context.read<GetListLogBloc>().add(
                                              GetListLogAction(
                                                actionType: GetLogVehicleActionEnum.refresh,
                                                reqData: GetLogVehicleRequestModelV2(
                                                  limit: 10,
                                                  currentPage: 1,
                                                ),
                                              ),
                                            );
                                      },
                                      onLoading: () {
                                        context.read<GetListLogBloc>().add(
                                              GetListLogAction(
                                                actionType: GetLogVehicleActionEnum.loadMore,
                                                reqData: GetLogVehicleRequestModelV2(
                                                  limit: 10,
                                                  currentPage: 1,
                                                ),
                                              ),
                                            );
                                      },
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: newDataDialog!.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.to(
                                                () => EditMeasurementPageVersion2(
                                                  data: newDataDialog![index],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                                horizontal: 8.h,
                                              ),
                                              child: Text(
                                                '${(index + 1)}. ${newDataDialog![index].measurementTitle}: ${formatter.format(newDataDialog![index].updatedAt!.toLocal())}',
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 8.h);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        // color: AppColor.green,
                        color: AppColor.primary,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  padding: EdgeInsets.all(8.h),
                  child: Text(
                    "Update",
                    style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.primary,
                      // color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          SfCartesianChart(
            key: const Key("Expenses"),
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Expenses'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<ListDatumLogEntity, String>>[
              LineSeries<ListDatumLogEntity, String>(
                legendItemText: "Expenses",
                dataSource: newData1,
                xValueMapper: (ListDatumLogEntity sales, _) {
                  // AppLogger.debugLog("indxL $index");
                  return formatter2.format(sales.createdAt!.toLocal());
                },
                yValueMapper: (ListDatumLogEntity sales, _) {
                  return int.parse((sales.amountExpenses == "") ? "0" : sales.amountExpenses!);
                },
                // Enable data label
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              )
            ],
            // series: <LineSeries<SalesData, String>>[
            //   LineSeries<SalesData, String>(
            //     dataSource: <SalesData>[
            //       SalesData('Jan', 20000),
            //       SalesData('Feb', 28000),
            //       SalesData('Mar', 32000),
            //       SalesData('Apr', 35000),
            //       SalesData('May', 30000),
            //     ],
            //     xValueMapper: (SalesData sales, _) => sales.year,
            //     yValueMapper: (SalesData sales, _) => sales.sales,
            //     // Enable data label
            //     dataLabelSettings: DataLabelSettings(
            //       isVisible: true,
            //     ),
            //   )
            // ],
          ),
          SizedBox(height: 10.h),
          SfCartesianChart(
            key: const Key("Odo Changes"),
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Odo Changes'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<ListDatumLogEntity, String>>[
              LineSeries<ListDatumLogEntity, String>(
                legendItemText: "Odo Changes",
                dataSource: newData,
                xValueMapper: (ListDatumLogEntity sales, _) {
                  return formatter2.format(sales.createdAt!.toLocal());
                },
                yValueMapper: (ListDatumLogEntity sales, _) => int.parse((sales.currentOdo == "") ? "0" : sales.currentOdo!),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              )
            ],
            // series: <LineSeries<SalesData, String>>[
            //   LineSeries<SalesData, String>(
            //     dataSource: <SalesData>[
            //       SalesData('Jan', 20000),
            //       SalesData('Feb', 24200),
            //       SalesData('Mar', 28000),
            //       SalesData('Apr', 32900),
            //       SalesData('May', 36000),
            //     ],
            //     xValueMapper: (SalesData sales, _) => sales.year,
            //     yValueMapper: (SalesData sales, _) => sales.sales,
            //     // Enable data label
            //     dataLabelSettings: DataLabelSettings(
            //       isVisible: true,
            //     ),
            //   )
            // ],
          ),
        ],
      ),
    );
  }
}
