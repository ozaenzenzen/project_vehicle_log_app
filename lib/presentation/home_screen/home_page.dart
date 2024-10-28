import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_logger.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int indexClicked = 0;
  Color vehicleListColor = Colors.black38;
  UserDataEntity? accountDataUserModelHomePage;

  DateFormat formattedDate = DateFormat("dd MMM yyyy");

  PageController homeSectionPageController = PageController(
    initialPage: 0,
  );

  late List<_ChartData> data;
  late TooltipBehavior _tooltipA;
  late TooltipBehavior _tooltipB;

  Uint8List? profilePictureData;

  @override
  void initState() {
    data = [
      _ChartData('David', 25),
      _ChartData('Steve', 38),
    ];
    _tooltipA = TooltipBehavior(enable: true);
    _tooltipB = TooltipBehavior(enable: true);
    super.initState();
  }

  String countVehicle = "";

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
          ..read<ProfileBloc>().add(
            GetProfileRemoteAction(
              accountRepository: AppAccountReposistory(),
            ),
          )
          ..read<GetAllVehicleBloc>().add(
            GetAllVehicleRemoteAction(
              reqData: GetAllVehicleRequestModelV2(
                limit: 10,
                currentPage: 1,
              ),
              action: GetAllVehicleActionEnum.refresh,
            ),
          )
          ..read<GetListLogBloc>().add(
            GetListLogAction(
              actionType: GetLogVehicleActionEnum.refresh,
              reqData: GetLogVehicleRequestModelV2(
                limit: 10,
                currentPage: 1,
              ),
            ),
          );
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          color: AppColor.shape,
          padding: EdgeInsets.all(16.h),
          alignment: Alignment.center,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40.h),
                  headHomeSection(),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      homeVehicleSummarySection(),
                      SizedBox(height: 20.h),
                      homeListVehicleSection(),
                      SizedBox(height: 20.h),
                      homeListMeasurementSection(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headHomeSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileFailed) {
                    AppDialogAction.showFailedPopup(
                      context: context,
                      title: "Terjadi kesalahan",
                      description: state.errorMessage,
                      buttonTitle: "Kembali",
                    );
                  }
                },
                builder: (context, state) {
                  String name = "";
                  if (state is ProfileLoading) {
                    return SizedBox(
                      height: 40.h,
                      width: 150.w,
                      child: const SkeletonLine(),
                    );
                  }
                  if (state is ProfileFailed) {
                    name = "";
                  }
                  if (state is ProfileSuccess) {
                    name = state.userDataModel.name ?? "";
                  }
                  return Expanded(
                    child: Text(
                      "Hi, $name",
                      // "Hi, ${state.userDataModel.name}",
                      style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const ProfilePage());
                },
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return ClipOval(
                        child: SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            height: 80.h,
                            width: 80.h,
                          ),
                        ),
                      );
                    } else if (state is ProfileSuccess) {
                      if (state.dataProfilePicture != null) {
                        profilePictureData = state.dataProfilePicture;
                        //Version RnD
                        return ClipOval(
                          child: Image.memory(
                            profilePictureData!,
                            height: 80.h,
                            width: 80.h,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      /* if (state.userDataModel.profilePicture != null && state.userDataModel.profilePicture!.length > 30) {
                        // Version Stable
                        profilePictureData = base64Decode(state.userDataModel.profilePicture!);
                        return ClipOval(
                          child: Image.memory(
                            profilePictureData!,
                            // base64Decode(state.userDataModel.profilePicture!),
                            height: 80.h,
                            width: 80.h,
                            fit: BoxFit.cover,
                          ),
                        );
                      } */
                      else {
                        return CircleAvatar(
                          radius: 36.h,
                          backgroundColor: AppColor.primary,
                        );
                      }
                    } else {
                      return CircleAvatar(
                        radius: 36.h,
                        backgroundColor: AppColor.primary,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "Manage your vehicle mileage",
            style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
              // color: AppColor.text_4,
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Current Date: ${formattedDate.format(DateTime.now())}",
            style: AppTheme.theme.textTheme.titleLarge?.copyWith(
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget homeVehicleSummarySection() {
    return BlocBuilder<GetListLogBloc, GetListLogState>(
      builder: (context, state) {
        if (state is GetListLogSuccess) {
          return AppContainerBoxWidget(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Summary",
                    style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
                    builder: (context, state) {
                      if (state is GetAllVehicleSuccess) {
                        if (state.result != null) {
                          countVehicle = "${state.result!.totalItems!}";
                        } else {
                          countVehicle = "";
                        }
                      } else {
                        countVehicle = "";
                      }
                      return Text(
                        "Number of Vehicle: $countVehicle",
                        // "Number of Vehicle: ${state.result?.totalItems}",
                        style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Measurement: ${state.result?.collectionLogData?.measurementTitles}",
                    // "Measurement: Oil, Water",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Last Update: ${formattedDate.format(state.result!.collectionLogData!.lastCreatedAt!.toLocal())}",
                    // "Last Update: 16 Nov 2022",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 170.h,
                        width: 170.h,
                        child: SfCircularChart(
                          title: ChartTitle(
                            text: "Frequent Measurment",
                            textStyle: GoogleFonts.inter(
                              color: Colors.black38,
                              fontSize: 10.sp,
                            ),
                          ),
                          tooltipBehavior: _tooltipA,
                          series: <CircularSeries<ChartData, String>>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: state.dataCountFrequentTitle,
                              xValueMapper: (ChartData data, ints) => data.x,
                              yValueMapper: (ChartData data, ints) => data.y,
                              name: 'Most Frequent Measurment',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 170.h,
                        width: 170.h,
                        child: SfCircularChart(
                          title: ChartTitle(
                            text: "Cost Breakdown",
                            textStyle: GoogleFonts.inter(
                              color: Colors.black38,
                              fontSize: 10.sp,
                            ),
                          ),
                          tooltipBehavior: _tooltipB,
                          series: <CircularSeries<ChartData, String>>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: state.dataCostBreakdown,
                              xValueMapper: (ChartData data, ints) => data.x,
                              yValueMapper: (ChartData data, ints) => data.y,
                              name: 'Cost Breakdown',
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 100.h,
                      //   width: 100.h,
                      //   child: SfCircularChart(
                      //     tooltipBehavior: _tooltipC,
                      //     series: <CircularSeries<_ChartData, String>>[
                      //       DoughnutSeries<_ChartData, String>(
                      //         dataSource: data,
                      //         xValueMapper: (_ChartData data, ints) => data.x,
                      //         yValueMapper: (_ChartData data, ints) => data.y,
                      //         name: 'Gold',
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is GetListLogLoading) {
          return SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: MediaQuery.of(context).size.width,
              height: 200.h,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget homeListVehicleSection() {
    return BlocConsumer<GetAllVehicleBloc, GetAllVehicleState>(
      listener: (context, state) {
        if (state is GetAllVehicleLoading) {
          AppLogger.debugLog("Listen loading ngga? 1");
          setState(() {});
        }
        // if (state is GetAllVehicleSuccess) {
        //   setState(() {
        //     countVehicle = state.result!.totalItems ?? 0;
        //     debugPrint("countVehicle $countVehicle");
        //   });
        // }
      },
      builder: (context, state) {
        AppLogger.debugLog("State here: $state");
        if (state is GetAllVehicleLoading) {
          AppLogger.debugLog("Kepanggil loading ngga? 1");
          return SkeletonLine(
            style: SkeletonLineStyle(
              width: MediaQuery.of(context).size.width,
              height: 20.h,
            ),
          );
        } else if (state is GetAllVehicleSuccess) {
          if (state.result == null || state.result!.listData!.isEmpty) {
            return const SizedBox();
          }
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.result?.listData?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      debugPrint("test hit $index");
                      indexClicked = index;
                      vehicleListColor = AppColor.white;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: index == indexClicked ? AppColor.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.result!.listData![index].vehicleName!,
                      // state.getAllVehicleDataResponseModel!.data![index].vehicleName!,
                      style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                        color: index == indexClicked ? AppColor.white : Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget homeListMeasurementSection() {
    return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
      builder: (context, state) {
        if (state is GetAllVehicleLoading) {
          AppLogger.debugLog("Kepanggil loading ngga? 2");
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20.h,
              mainAxisSpacing: 20.h,
              crossAxisCount: 2,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return const SkeletonAvatar();
            },
          );
        } else if (state is GetAllVehicleSuccess) {
          if (state.result == null || state.result!.listData!.isEmpty || state.result!.listData![indexClicked].measurmentTitle!.isEmpty) {
            return const SizedBox();
          } else {
            return ListMeasurementWidgetV2(
              data: state.result!.listData!,
              indexInput: indexClicked,
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ListMeasurementWidgetV2 extends StatelessWidget {
  // final List<String> data;
  final List<ListDatumVehicleDataEntity>? data;
  final int indexInput;

  const ListMeasurementWidgetV2({
    Key? key,
    required this.data,
    required this.indexInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 20.h,
        mainAxisSpacing: 20.h,
        crossAxisCount: 2,
      ),
      itemCount: data?[indexInput].measurmentTitle?.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<GetListLogBloc>().add(
                  GetListLogAction(
                    actionType: GetLogVehicleActionEnum.refresh,
                    reqData: GetLogVehicleRequestModelV2(
                      limit: 10,
                      currentPage: 1,
                      sortOrder: "DESC",
                      vehicleId: data![indexInput].id.toString(),
                    ),
                  ),
                );
            Get.to(
              () => DetailMeasurementPage(
                data: data![indexInput],
                indexMeasurement: index,
                listMeasurementTitleByGroup: data![indexInput].measurmentTitle,
              ),
            );
          },
          child: AppContainerBoxWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop,
                  size: 90.h,
                  color: AppColor.primary,
                ),
                SizedBox(height: 10.h),
                Text(
                  data![indexInput].measurmentTitle![index],
                  style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y, [
    this.color,
  ]);
  final String x;
  final dynamic y;
  // final num y;
  final Color? color;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
