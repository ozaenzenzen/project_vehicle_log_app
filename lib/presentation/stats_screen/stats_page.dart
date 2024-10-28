import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_measurement_page.dart';

import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/support/app_assets.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
          context.read<GetAllVehicleBloc>().add(
                GetAllVehicleRemoteAction(
                  reqData: GetAllVehicleRequestModelV2(
                    limit: 10,
                    currentPage: 1,
                  ),
                  action: GetAllVehicleActionEnum.refresh,
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
                BlocConsumer<GetAllVehicleBloc, GetAllVehicleState>(
                  listener: (context, state) {
                    if (state is GetAllVehicleSuccess) {
                      refreshController.refreshCompleted();
                      if (state.result!.listData!.isEmpty) {
                        dropDownValue = null;
                      } else {
                        dropDownValue = state.result!.listData!.first;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is GetAllVehicleLoading) {
                      return loadingView();
                    } else if (state is GetAllVehicleFailed) {
                      return failedView(state);
                    } else if (state is GetAllVehicleSuccess) {
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

  Widget failedView(GetAllVehicleFailed state) {
    return Text(state.errorMessage);
  }

  Widget initialView() {
    return const SizedBox();
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

  Widget successView(GetAllVehicleSuccess state) {
    if (state.result!.listData!.isEmpty) {
      // return const SizedBox();
      return newEmptyState(
        title: "Anda belum menambahkan data kendaraan",
      );
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
          (state
                  .result!
                  .listData![(state.result!.listData!.indexWhere((element) {
                            return element.id == dropDownValue?.id;
                          }) <
                          0)
                      ? 0
                      : state.result!.listData!.indexWhere((element) {
                          return element.id == dropDownValue?.id;
                        })]
                  .measurmentTitle!
                  .isEmpty)
              ? newEmptyState(
                  title: "Anda belum menambahkan data pengukuran",
                )
              : ListView.separated(
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
                        context.read<GetListLogBloc>().add(
                              GetListLogAction(
                                actionType: GetLogVehicleActionEnum.refresh,
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
                          () => DetailMeasurementPage(
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
