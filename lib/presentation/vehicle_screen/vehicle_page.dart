import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_vehicle_page.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  @override
  void dispose() {
    super.dispose();
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<ListDatumVehicleDataEntity> listData = [];

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
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
        context.read<GetAllVehicleBloc>().add(
              GetAllVehicleRemoteAction(
                reqData: GetAllVehicleRequestModelV2(
                  limit: 10,
                  currentPage: 1,
                ),
                action: GetAllVehicleActionEnum.loadMore,
              ),
            );
      },
      child: SingleChildScrollView(
        child: Container(
          color: AppColor.shape,
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                "Your Vehicle",
                style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Choose your vehicle",
                style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              BlocConsumer<GetAllVehicleBloc, GetAllVehicleState>(
                listener: (context, state) {
                  if (state is GetAllVehicleSuccess) {
                    if (state.action == GetAllVehicleActionEnum.refresh) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.loadComplete();
                    }
                  }
                  if (state is GetAllVehicleFailed) {
                    refreshController.refreshCompleted();
                    refreshController.loadComplete();
                  }
                },
                builder: (context, state) {
                  if (state is GetAllVehicleLoading) {
                    if (state.action == GetAllVehicleActionEnum.refresh) {
                      return loadingView();
                    }
                  }
                  if (state is GetAllVehicleSuccess) {
                    listData = state.result!.listData!;
                  }
                  return successView(listData);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget initialView() {
    return const SizedBox();
  }

  // Widget successView(GetAllVehicleSuccess state) {
  Widget successView(List<ListDatumVehicleDataEntity> listDataHere) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // itemCount: state.getAllVehicleDataResponseModel == null ? 0 : state.getAllVehicleDataResponseModel!.data!.length,
      // itemCount: state.result != null ? state.result!.listData!.length : 0,
      itemCount: listDataHere.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<GetListLogBloc>().add(
                  GetListLogAction(
                    reqData: GetLogVehicleRequestModelV2(
                      limit: 10,
                      currentPage: 1,
                      sortOrder: "DESC",
                      vehicleId: "${listDataHere[index].id}",
                    ),
                    actionType: GetLogVehicleActionEnum.refresh,
                  ),
                );
            Get.to(
              () => DetailVehiclePage(
                // indexMeasurement: index,
                datumVehicle: listDataHere[index],
                idVehicle: listDataHere[index].id!,
                listMeasurementTitleByGroup: listDataHere[index].measurmentTitle,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 1,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40.h,
                  backgroundColor: AppColor.primary,
                  child: (listDataHere[index].vehicleImage == "x" || listDataHere[index].vehicleImage!.length < 40 || listDataHere[index].vehicleImage == null)
                      ? ClipOval(
                          child: Image.network(
                            "https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw",
                            fit: BoxFit.cover,
                            height: 80.h,
                            width: 80.h,
                          ),
                        )
                      : ClipOval(
                          child: Image.memory(
                            base64Decode(listDataHere[index].vehicleImage!),
                            fit: BoxFit.cover,
                            height: 80.h,
                            width: 80.h,
                          ),
                        ),
                ),
                SizedBox(width: 25.w),
                Column(
                  children: [
                    Text(
                      // "${DummyData.dummyData[index].vehicleName}",
                      listDataHere[index].vehicleName!,
                      // "Vehicle $index",
                      style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20.h,
        );
      },
    );
  }

  Widget loadingView() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return SkeletonLine(
          style: SkeletonLineStyle(
            height: 90.h,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20.h,
        );
      },
    );
  }
}
