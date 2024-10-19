import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_v2_bloc/get_all_vehicle_v2_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/hp2_get_list_log_bloc/hp2_get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page_version2.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageVersion2 extends StatefulWidget {
  const HomePageVersion2({Key? key}) : super(key: key);

  @override
  State<HomePageVersion2> createState() => _HomePageVersion2State();
}

class _HomePageVersion2State extends State<HomePageVersion2> with TickerProviderStateMixin {
  int indexClicked = 0;
  Color vehicleListColor = Colors.black38;
  // AccountDataUserModel? accountDataUserModelHomePage;
  UserDataEntity? accountDataUserModelHomePage;

  DateFormat formattedDate = DateFormat("dd MMM yyyy");

  PageController homeSectionPageController = PageController(
    initialPage: 0,
  );

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // context
    // ..read<ProfileBloc>().add(
    //   GetProfileRemoteAction(
    //     accountRepository: AppAccountReposistory(),
    //   ),
    // )
    // ..read<GetAllVehicleV2Bloc>().add(
    //   GetAllVehicleV2LocalAction(
    //     reqData: GetAllVehicleRequestModelV2(
    //       limit: 10,
    //       currentPage: 1,
    //     ),
    //   ),
    // );
    // ..read<Hp2GetListLogBloc>().add(
    //   Hp2GetListLogAction(
    //     reqData: GetLogVehicleRequestModelV2(
    //       limit: 10,
    //       currentPage: 1,
    //     ),
    //   ),
    // )
    // ..read<GetAllVehicleBloc>().add(
    //   GetProfileDataVehicleAction(
    //     localRepository: AccountLocalRepository(),
    //   ),
    // );
    data = [
      _ChartData('David', 25),
      _ChartData('Steve', 38),
      // _ChartData('Jack', 34),
      // _ChartData('Others', 52),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

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
          ..read<GetAllVehicleV2Bloc>().add(
            GetAllVehicleV2RemoteAction(
              reqData: GetAllVehicleRequestModelV2(
                limit: 10,
                currentPage: 1,
              ),
            ),
          );
        // ..read<Hp2GetListLogBloc>().add(
        //   Hp2GetListLogAction(
        //     reqData: GetLogVehicleRequestModelV2(
        //       limit: 10,
        //       currentPage: 1,
        //     ),
        //   ),
        // )
        // ..read<GetAllVehicleBloc>().add(
        //   GetAllVehicleDataRemoteAction(
        //     id: accountDataUserModelHomePage!.id.toString(),
        //     vehicleLocalRepository: VehicleLocalRepository(),
        //   ),
        // );
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
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return SizedBox(
                      height: 40.h,
                      width: 150.w,
                      child: const SkeletonLine(),
                    );
                  } else if (state is ProfileFailed) {
                    return Text(state.errorMessage);
                  } else if (state is ProfileSuccess) {
                    return Expanded(
                      child: Text(
                        "Hi, ${state.userDataModel.name}",
                        style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      "Hi, User",
                      style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
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
                      if (state.userDataModel.profilePicture != null && state.userDataModel.profilePicture!.length > 30) {
                        return ClipOval(
                          child: Image.memory(
                            base64Decode(state.userDataModel.profilePicture!),
                            height: 80.h,
                            width: 80.h,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
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
    return BlocBuilder<GetAllVehicleV2Bloc, GetAllVehicleV2State>(
      builder: (context, state) {
        if (state is GetAllVehicleV2Success) {
          return AppContainerBoxWidget(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Summary",
                    style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Number of Vehicle: 8",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Critical: Oil, Water",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Last Update: 16 Nov 2022",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is GetAllVehicleV2Loading) {
          return SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: MediaQuery.of(context).size.width,
              height: 200.h,
            ),
          );
        } else {
          return AppContainerBoxWidget(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Summary",
                    style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Number of Vehicle: 8",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Critical: Oil, Water",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Last Update: 16 Nov 2022",
                    style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries<_ChartData, String>>[
                            DoughnutSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, ints) => data.x,
                              yValueMapper: (_ChartData data, ints) => data.y,
                              name: 'Gold',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget homeListVehicleSection() {
    return BlocConsumer<GetAllVehicleV2Bloc, GetAllVehicleV2State>(
      listener: (context, state) {
        if (state is GetAllVehicleV2Success) {
          if (state.result!.listData!.isNotEmpty) {
            context.read<Hp2GetListLogBloc>().add(
                  Hp2GetListLogAction(
                    reqData: GetLogVehicleRequestModelV2(
                      limit: 10,
                      currentPage: 1,
                      vehicleId: state.result!.listData!.first.id.toString(),
                    ),
                  ),
                );
          } else {
            // DO Nothing
          }
        }
      },
      // return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
      builder: (context, state) {
        if (state is GetAllVehicleV2Success) {
          // if (state is GetAllVehicleSuccess) {
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.result?.listData?.length,
              // itemCount: state.getAllVehicleDataResponseModel!.data!.length,
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
        } else if (state is GetAllVehicleV2Loading) {
          // } else if (state is GetAllVehicleLoading) {
          return SkeletonLine(
            style: SkeletonLineStyle(
              width: MediaQuery.of(context).size.width,
              height: 20.h,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget homeListMeasurementSection() {
    return BlocBuilder<GetAllVehicleV2Bloc, GetAllVehicleV2State>(
      builder: (context, state) {
        if (state is GetAllVehicleV2Success) {
          if (state.result!.listData![indexClicked].measurmentTitle!.isEmpty) {
            return const SizedBox();
          } else {
            return ListMeasurementWidgetV2(
              data: state.result!.listData!,
              indexInput: indexClicked,
            );
          }
        } else if (state is GetAllVehicleV2Loading) {
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
            context.read<Hp2GetListLogBloc>().add(
                  Hp2GetListLogAction(
                    reqData: GetLogVehicleRequestModelV2(
                      limit: 10,
                      currentPage: 1,
                      sortOrder: "DESC",
                      vehicleId: data![indexInput].id.toString(),
                    ),
                  ),
                );
            Get.to(
              () => DetailMeasurementPageVersion2(
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
  final double y;
  final Color? color;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
