import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/detail_measurement_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:skeletons/skeletons.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<DatumVehicle>? dataStats;
  DatumVehicle? dropDownValue;
  int indexChosen = 0;

  FocusNode dropDownFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetAllVehicleBloc>(
      create: (context) => GetAllVehicleBloc(AppVehicleReposistory())
        ..add(
          GetAllVehicleDataLocalAction(
            vehicleLocalRepository: VehicleLocalRepository(),
          ),
        ),
      child: GestureDetector(
        onTap: () {
          dropDownFocusNode.unfocus();
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
                      if (state.getAllVehicleDataResponseModel!.data!.isEmpty) {
                        dropDownValue = null;
                      } else {
                        dropDownValue = state.getAllVehicleDataResponseModel!.data!.first;
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

  Widget successView(GetAllVehicleSuccess state) {
    if (state.getAllVehicleDataResponseModel!.data!.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<DatumVehicle>(
            focusNode: dropDownFocusNode,
            items: state.getAllVehicleDataResponseModel!.data?.map((DatumVehicle e) {
              return DropdownMenuItem<DatumVehicle>(
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
            value: state.getAllVehicleDataResponseModel!.data!.first,
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
            itemCount: state.getAllVehicleDataResponseModel == null
                ? 0
                : state
                    .getAllVehicleDataResponseModel!
                    .data![(state.getAllVehicleDataResponseModel!.data!.indexWhere((element) {
                              return element == dropDownValue;
                            }) <
                            0)
                        ? 0
                        : state.getAllVehicleDataResponseModel!.data!.indexWhere((element) {
                            return element == dropDownValue;
                          })]
                    .categorizedData!
                    .length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(
                    () => DetailMeasurementPage(
                      data: state.getAllVehicleDataResponseModel!.data![(state.getAllVehicleDataResponseModel!.data!.indexWhere((DatumVehicle element) {
                                return element == dropDownValue;
                              }) <
                              0)
                          ? 0
                          : state.getAllVehicleDataResponseModel!.data!.indexWhere((DatumVehicle element) {
                              return element == dropDownValue;
                            })],
                      index: index,
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
                              .getAllVehicleDataResponseModel!
                              .data![(state.getAllVehicleDataResponseModel!.data!.indexWhere((DatumVehicle element) {
                                        return element == dropDownValue;
                                      }) <
                                      0)
                                  ? 0
                                  : state.getAllVehicleDataResponseModel!.data!.indexWhere((DatumVehicle element) {
                                      return element == dropDownValue;
                                    })]
                              .categorizedData![index]
                              .measurementTitle!,
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
