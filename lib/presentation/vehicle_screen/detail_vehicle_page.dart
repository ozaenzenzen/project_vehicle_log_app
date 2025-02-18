import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/enum/status_logs_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/edit_vehicle_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/widget/dvp_stats_item_widget.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/widget/list_item_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/support/app_assets.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/add_measurement_page.dart';

// enum StatusLogs { add, update, delete }

class DetailVehiclePage extends StatefulWidget {
  // final int indexMeasurement;
  final int idVehicle;
  final ListDatumVehicleDataEntity datumVehicle;
  final List<String>? listMeasurementTitleByGroup;

  const DetailVehiclePage({
    Key? key,
    // required this.indexMeasurement,
    required this.idVehicle,
    required this.datumVehicle,
    required this.listMeasurementTitleByGroup,
  }) : super(key: key);

  @override
  State<DetailVehiclePage> createState() => _DetailVehiclePageState();
}

class _DetailVehiclePageState extends State<DetailVehiclePage> with TickerProviderStateMixin {
  late TabController tabController;

  TooltipBehavior? tooltipBehavior;

  List<ListDatumLogEntity> sortedListLogs = [];

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    tabController = TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  TabBar get _tabBar => TabBar(
        // unselectedLabelColor: AppColor.disabled,
        controller: tabController,
        labelColor: AppColor.white,
        unselectedLabelColor: AppColor.white,
        tabs: const [
          Tab(
            text: "Info",
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
          Tab(
            text: "Logs",
            icon: Icon(
              Icons.list_rounded,
              color: Colors.white,
            ),
          ),
          Tab(
            text: "Stats",
            icon: Icon(
              Icons.legend_toggle_sharp,
              color: Colors.white,
            ),
          ),
        ],
      );

  infoView() {
    return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
      builder: (context, state) {
        if (state is GetAllVehicleLoading) {
          return const AppLoadingIndicator();
        } else if (state is GetAllVehicleFailed) {
          return Text(state.errorMessage);
        } else if (state is GetAllVehicleSuccess) {
          int newIndex = state.result!.listData!.indexWhere((element) {
            return element.id == widget.datumVehicle.id;
          });
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // "Name Vehicle",
                    state.result!.listData![newIndex].vehicleName!,
                    style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                      // color: AppColor.text_4,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  (state.result!.listData![newIndex].vehicleImage == null || state.result!.listData![newIndex].vehicleImage!.length < 30)
                      ? Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw")
                      : SizedBox(
                          // child: Image.network("https://media.istockphoto.com/id/1096052566/vector/stamprsimp2red.jpg?s=612x612&w=0&k=20&c=KVu0nVz7ZLbZsRsx81VBZcuXZ1MlEmLk9IQabO2GkYo="),
                          // child: Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw"),
                          child: Image.memory(
                            base64Decode(
                              state.result!.listData![newIndex].vehicleImage!,
                            ),
                            height: 200.h,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw");
                            },
                          ),
                        ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Main Info",
                        style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => EditVehiclePage(
                              data: state.result!.listData!.firstWhere((element) => element.id == widget.idVehicle),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit_square,
                          size: 25.h,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Year",
                    value: state.result!.listData![newIndex].year,
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Engine Capacity (cc)",
                    value: state.result!.listData![newIndex].engineCapacity,
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Tank Capacity (Litre)",
                    value: state.result!.listData![newIndex].tankCapacity,
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Color",
                    value: state.result!.listData![newIndex].color,
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Machine Number",
                    value: state.result!.listData![newIndex].machineNumber,
                  ),
                  SizedBox(height: 10.h),
                  ItemListWidget(
                    title: "Chassis Number",
                    value: state.result!.listData![newIndex].chassisNumber,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text("data is null");
        }
      },
    );
  }

  RefreshController logsViewRefreshController = RefreshController(initialRefresh: false);
  List<ListDatumLogEntity> listData = [];

  logsView() {
    return SmartRefresher(
      controller: logsViewRefreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () {
        context.read<GetListLogBloc>().add(
              GetListLogAction(
                actionType: GetLogVehicleActionEnum.refresh,
                reqData: GetLogVehicleRequestModelV2(
                  limit: 10,
                  currentPage: 1,
                  vehicleId: "${widget.idVehicle}",
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
                  vehicleId: "${widget.idVehicle}",
                ),
              ),
            );
      },
      child: BlocConsumer<GetListLogBloc, GetListLogState>(
        listener: (context, state) {
          if (state is GetListLogSuccess) {
            if (state.actionType == GetLogVehicleActionEnum.refresh) {
              logsViewRefreshController.refreshCompleted();
            } else {
              logsViewRefreshController.loadComplete();
            }
          }
        },
        builder: (context, state) {
          if (state is GetListLogLoading) {
            if (state.actionType == GetLogVehicleActionEnum.refresh) {
              // return const AppLoadingIndicator();
              return loadingSkeletonState();
            }
          }
          if (state is GetListLogSuccess) {
            listData = state.result!.listData!;
          }
          sortedListLogs = listData;
          sortedListLogs.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return SingleChildScrollView(
            child: Container(
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
                  sortedListLogs.isEmpty
                      ? newEmptyState(
                          title: "Anda belum melakukan perubahan",
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // itemCount: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels.length,
                          itemCount: sortedListLogs.length,
                          itemBuilder: (context, index) {
                            return ItemListWidget.logs(
                              // title: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels[index].measurementTitle,
                              title: sortedListLogs[index].measurementTitle,
                              statusLogs: StatusLogs.add,
                              // vehicleMeasurementLogModels: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels[index],
                              vehicleMeasurementLogModels: sortedListLogs[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10.h);
                          },
                        ),
                  // SizedBox(height: 5.h),
                  // Center(
                  //   child: Text(
                  //     "See more",
                  //     style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                  //       decoration: TextDecoration.underline,
                  //       color: AppColor.blue,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SingleChildScrollView loadingSkeletonState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 18,
        itemBuilder: (context, index) {
          return SkeletonAvatar(
            style: SkeletonAvatarStyle(
              height: 240.h,
              width: MediaQuery.of(context).size.width,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10.h);
        },
      ),
    );
  }

  statsView() {
    return BlocBuilder<GetListLogBloc, GetListLogState>(
      builder: (context, state) {
        if (state is GetListLogLoading) {
          return const AppLoadingIndicator();
        } else if (state is GetListLogFailed) {
          return Text(state.errorMessage);
        } else if (state is GetListLogSuccess) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
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
                  state.result!.listData!.isEmpty
                      ? newEmptyState(
                          title: "Anda belum menambahkan pengukuran",
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // itemCount: state.result!.listData!.length,
                          // itemCount: widget.indexMeasurement + 1,
                          itemCount: widget.listMeasurementTitleByGroup!.length,
                          itemBuilder: (context, index) {
                            return DVPStatsItemWidget(
                              // title: state
                              //     .result!
                              //     .listData![state.result!.listData!.indexWhere((element) {
                              //   return element.measurementTitle == widget.datumVehicle.measurmentTitle![widget.index];
                              // })].measurementTitle,
                              title: widget.listMeasurementTitleByGroup![index],
                              vehicleId: widget.idVehicle.toString(),
                              // title: "Test Title",
                              data: state.result!.listData!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10.h);
                          },
                        ),
                  // const DVPStatsItemWidget(
                  //   title: "Oil",
                  // ),
                  // SizedBox(height: 10.h),
                  // const DVPStatsItemWidget(
                  //   title: "Radiator",
                  // ),
                  // SizedBox(height: 10.h),
                  // const DVPStatsItemWidget(
                  //   title: "Side Oil",
                  // ),
                ],
              ),
            ),
          );
        } else {
          return const Text("data is null");
        }
      },
    );
  }

  Widget emptyState() {
    return SizedBox(
      height: 250.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You haven't yet set measurement",
            style: AppTheme.theme.textTheme.bodyLarge?.copyWith(
              // color: AppColor.text_4,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          AppMainButtonWidget(
            onPressed: () {
              Get.to(() => AddMeasurementPage(
                    vehicleId: widget.datumVehicle.id!,
                  ));
            },
            text: "Add Now",
          ),
        ],
      ),
    );
  }

  Widget newEmptyState({
    required String title,
  }) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Image.asset(
          AppAssets.imgEmptyStateBlue,
          height: 200.h,
        ),
        SizedBox(height: 12.h),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      floatingActionButton: FloatingActionButton.extended(
        key: const Key("DVPFAB"),
        heroTag: const Key("DVPFAB"),
        backgroundColor: AppColor.primary,
        onPressed: () {
          Get.to(
            () => AddMeasurementPage(
              vehicleId: widget.datumVehicle.id!,
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
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 10,
        shadowColor: const Color(0xff101828),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Detail Vehicle Page",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: _tabBar,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          infoView(),
          logsView(),
          statsView(),
        ],
      ),
    );
  }
}
