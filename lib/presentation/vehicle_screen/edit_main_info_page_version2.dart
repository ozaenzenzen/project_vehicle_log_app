import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/edit_vehicle_bloc/edit_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_image_picker.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class EditMainInfoPageVersion2 extends StatefulWidget {
  final ListDatumVehicleDataEntity data;

  const EditMainInfoPageVersion2({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditMainInfoPageVersion2> createState() => _EditMainInfoPageVersion2State();
}

class _EditMainInfoPageVersion2State extends State<EditMainInfoPageVersion2> {
  int? vehicleId;

  String imagePickedInBase64 = "";
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController engineCapacityController = TextEditingController();
  TextEditingController tankCapacityController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController machineNumberController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();

  late EditVehicleBloc editVehicleBloc;

  @override
  void initState() {
    super.initState();
    editVehicleBloc = EditVehicleBloc();

    vehicleId = widget.data.id!;
    imagePickedInBase64 = widget.data.vehicleImage!;
    vehicleNameController.text = widget.data.vehicleName!;
    yearController.text = widget.data.year!;
    engineCapacityController.text = widget.data.engineCapacity!;
    tankCapacityController.text = widget.data.tankCapacity!;
    colorController.text = widget.data.color!;
    machineNumberController.text = widget.data.machineNumber!;
    chassisNumberController.text = widget.data.chassisNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => editVehicleBloc,
      child: BlocListener<EditVehicleBloc, EditVehicleState>(
        listener: (context, state) {
          if (state is EditVehicleSuccess) {
            AppDialogAction.showSuccessPopup(
              context: context,
              title: 'Berhasil',
              description: state.editVehicleResponseModel.message,
              buttonTitle: 'Kembali',
              mainButtonAction: () {
                Get.offAll(() => const MainPage());
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
            );
          }
          if (state is EditVehicleFailed) {
            AppDialogAction.showFailedPopup(
              context: context,
              title: 'Terjadi kesalahan',
              description: state.errorMessage,
              buttonTitle: 'Kembali',
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: const AppBarWidget(
              title: "Edit Vehicle",
            ),
            resizeToAvoidBottomInset: true,
            bottomSheet: bottomSheetSection(),
            body: Stack(
              children: [
                bodyView(),
                BlocBuilder<EditVehicleBloc, EditVehicleState>(
                  builder: (context, state) {
                    if (state is EditVehicleLoading) {
                      return loadingView();
                    } else {
                      return const SizedBox();
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

  BlocBuilder<EditVehicleBloc, EditVehicleState> bottomSheetSection() {
    return BlocBuilder<EditVehicleBloc, EditVehicleState>(
            builder: (context, state) {
              return AppBottomNavBarButtonWidget(
                onTap: () {
                  // Get.off(() => const MainPage());
                  context.read<EditVehicleBloc>().add(
                        EditVehicleAction(
                          appVehicleReposistory: AppVehicleReposistory(),
                          editVehicleRequestModel: EditVehicleRequestModel(
                            vehicleId: vehicleId!,
                            vehicleName: vehicleNameController.text,
                            vehicleImage: imagePickedInBase64 == "" ? null : imagePickedInBase64,
                            year: yearController.text,
                            engineCapacity: engineCapacityController.text,
                            tankCapacity: tankCapacityController.text,
                            color: colorController.text,
                            machineNumber: machineNumberController.text,
                            chassisNumber: chassisNumberController.text,
                          ),
                        ),
                      );
                },
                title: "Edit Vehicle",
              );
            },
          );
  }

  Widget bodyView() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColor.white,
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Vehicle",
              style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Edit your vehicle alongside with measurement parameter",
              style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Vehicle Image",
              style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xff331814),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () async {
                imagePickedInBase64 = await AppImagePickerService().getImageAsBase64().then(
                  (value) {
                    setState(() {});
                    return value!;
                  },
                );
              },
              child: (imagePickedInBase64 == "")
                  ? DottedBorder(
                      radius: const Radius.circular(20),
                      dashPattern: const [7, 3],
                      strokeWidth: 2,
                      color: AppColor.blue,
                      child: Container(
                        height: 200.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.border,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              size: 24.h,
                              color: AppColor.blue,
                            ),
                            SizedBox(width: 18.h),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Browse File",
                                  style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.blue,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Format dokumen .jpg",
                                  style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                                    color: AppColor.disabled,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.h),
                                child: imagePickedInBase64.length > 30
                                    ? Image.memory(
                                        base64Decode(base64.normalize(imagePickedInBase64)),
                                        height: 190.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        "https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw",
                                        height: 190.h,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: 10.h,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("Test ontap");
                                  setState(() {
                                    imagePickedInBase64 = "";
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.65),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 25.h,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Vehicle Name",
              textFieldHintText: "Vehicle Name",
              controller: vehicleNameController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Year",
              textFieldHintText: "Year",
              controller: yearController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Engine Capacity (cc)",
              textFieldHintText: "ex: 250",
              controller: engineCapacityController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Tank Capacity (Litre)",
              textFieldHintText: "ex: 250",
              controller: tankCapacityController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Color",
              textFieldHintText: "Color",
              controller: colorController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Machine Number",
              textFieldHintText: "Machine Number",
              controller: machineNumberController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Chassis Number",
              textFieldHintText: "Chassis Number",
              controller: chassisNumberController,
            ),
            SizedBox(height: 20.h),
            SizedBox(height: kToolbarHeight + 30.h),
          ],
        ),
      ),
    );
  }

  Widget loadingView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.h,
            width: 50.h,
            child: const CircularProgressIndicator(),
          ),
          SizedBox(height: 24.h),
          Text(
            'Proses sedang berlangsung',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
