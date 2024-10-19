import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_v2_bloc/get_all_vehicle_v2_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/hp2_get_list_log_bloc/hp2_get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page_version2.dart';

import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

class StatsPageVersion2 extends StatefulWidget {
  const StatsPageVersion2({Key? key}) : super(key: key);

  @override
  State<StatsPageVersion2> createState() => _StatsPageVersion2State();
}

class _StatsPageVersion2State extends State<StatsPageVersion2> {
  // List<DatumVehicle>? dataStats;
  // DatumVehicle? dropDownValue;
  ListDatumVehicleDataEntity? dropDownValue;
  // int indexChosen = 0;

  FocusNode dropDownFocusNode = FocusNode();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dropDownFocusNode.unfocus();
      },
      child: SmartRefresher(
        enablePullDown: true,
        controller: refreshController,
        onRefresh: () {
          context.read<GetAllVehicleV2Bloc>().add(
                GetAllVehicleV2RemoteAction(
                  reqData: GetAllVehicleRequestModelV2(
                    limit: 10,
                    currentPage: 1,
                  ),
                ),
              );
        },
        onLoading: () {
          //
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Stats",
                  style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Show stats based on your vehicle",
                  style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                BlocConsumer<GetAllVehicleV2Bloc, GetAllVehicleV2State>(
                  listener: (context, state) {
                    if (state is GetAllVehicleV2Success) {
                      refreshController.refreshCompleted();
                      if (state.result!.listData!.isEmpty) {
                        dropDownValue = null;
                      } else {
                        dropDownValue = state.result!.listData!.first;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is GetAllVehicleV2Loading) {
                      return loadingView();
                    } else if (state is GetAllVehicleV2Failed) {
                      return failedView(state);
                    } else if (state is GetAllVehicleV2Success) {
                      return successView(state);
                    } else {
                      return initialView();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget failedView(GetAllVehicleV2Failed state) {
    return Text(state.errorMessage);
  }

  Widget initialView() {
    return const SizedBox();
  }

  Widget successView(GetAllVehicleV2Success state) {
    if (state.result!.listData!.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<ListDatumVehicleDataEntity>(
            focusNode: dropDownFocusNode,
            items: state.result!.listData!.map((ListDatumVehicleDataEntity e) {
              return DropdownMenuItem<ListDatumVehicleDataEntity>(
                value: e,
                child: Text(
                  e.vehicleName ?? "",
                  style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              debugPrint("on changed $value");
              setState(() {
                dropDownValue = value;
              });
              dropDownFocusNode.unfocus();
            },
            value: state.result!.listData!.first,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.result == null
                ? 0
                : state
                    .result!
                    .listData![(state.result!.listData!.indexWhere((element) {
                              return element == dropDownValue;
                            }) <
                            0
                        ? 0
                        : state.result!.listData!.indexWhere((element) {
                            return element == dropDownValue;
                          }))]
                    .measurmentTitle!
                    .length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.read<Hp2GetListLogBloc>().add(
                        Hp2GetListLogAction(
                          reqData: GetLogVehicleRequestModelV2(
                            limit: 10,
                            currentPage: 1,
                            sortOrder: "DESC",
                            vehicleId: state
                                .result!
                                .listData![(state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                                          return element == dropDownValue;
                                        }) <
                                        0)
                                    ? 0
                                    : state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                                        return element == dropDownValue;
                                      })]
                                .id
                                .toString(),
                          ),
                        ),
                      );
                  Get.to(
                    () => DetailMeasurementPageVersion2(
                      data: state.result!.listData![(state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                                return element == dropDownValue;
                              }) <
                              0)
                          ? 0
                          : state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                              return element == dropDownValue;
                            })],
                      indexMeasurement: index,
                      listMeasurementTitleByGroup: state
                          .result!
                          .listData![(state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                                    return element == dropDownValue;
                                  }) <
                                  0)
                              ? 0
                              : state.result!.listData!.indexWhere((ListDatumVehicleDataEntity element) {
                                  return element == dropDownValue;
                                })]
                          .measurmentTitle,
                    ),
                  );
                },
                child: AppContainerBoxWidget(
                  height: 200.h,
                  child: Center(
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
                          state
                              .result!
                              .listData![(state.result!.listData!.indexWhere((element) {
                                        return element.id == dropDownValue?.id;
                                      }) <
                                      0)
                                  ? 0
                                  : state.result!.listData!.indexWhere((element) {
                                      return element.id == dropDownValue?.id;
                                    })]
                              .measurmentTitle![index],
                          style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 20.h);
            },
          ),
        ],
      );
    }
  }

  Widget loadingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 50.h,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return SkeletonLine(
              style: SkeletonLineStyle(
                height: 150.h,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 20.h);
          },
        ),
      ],
    );
  }
}
