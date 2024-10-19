import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/detail_vehicle_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetAllVehicleBloc(AppVehicleReposistory())
        ..add(
          GetProfileDataVehicleAction(
            localRepository: AccountLocalRepository(),
          ),
        ),
      child: BlocListener<GetAllVehicleBloc, GetAllVehicleState>(
        listener: (context, state) {
          if (state is GetProfileDataVehicleSuccess) {
            context.read<GetAllVehicleBloc>().add(
                  // GetAllVehicleDataAction(
                  //   id: state.accountDataUserModel.userId.toString(),
                  // ),
                  GetAllVehicleDataLocalAction(
                    vehicleLocalRepository: VehicleLocalRepository(),
                  ),
                );
          }
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
                BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
                  builder: (context, state) {
                    if (state is GetAllVehicleLoading) {
                      return loadingView();
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

  Widget initialView() {
    return const SizedBox();
  }

  Widget successView(GetAllVehicleSuccess state) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.getAllVehicleDataResponseModel == null ? 0 : state.getAllVehicleDataResponseModel!.data!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(
              () => DetailVehiclePage(
                index: index,
                datumVehicle: state.getAllVehicleDataResponseModel!.data![index],
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
                  child: state.getAllVehicleDataResponseModel!.data![index].vehicleImage == "x"
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
                            base64Decode(state.getAllVehicleDataResponseModel!.data![index].vehicleImage!),
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
                      state.getAllVehicleDataResponseModel!.data![index].vehicleName!,
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
