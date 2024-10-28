import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/edit_vehicle_bloc/edit_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_image_picker.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class EditVehiclePage extends StatefulWidget {
  final ListDatumVehicleDataEntity data;

  const EditVehiclePage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  int? vehicleId;

  String imagePickedInBase64 = "";
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController engineCapacityController = TextEditingController();
  TextEditingController tankCapacityController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController machineNumberController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();

  FocusNode vehicleNameFocusNode = FocusNode();
  FocusNode yearFocusNode = FocusNode();
  FocusNode engineCapacityFocusNode = FocusNode();
  FocusNode tankCapacityFocusNode = FocusNode();
  FocusNode colorFocusNode = FocusNode();
  FocusNode machineNumberFocusNode = FocusNode();
  FocusNode chassisNumberFocusNode = FocusNode();

  late EditVehicleBloc editVehicleBloc;

  bool isLoadingActive = false;

  final _scrollController = ScrollController();

  void scrollToFocusedTextField(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && focusNode.hasFocus) {
        _scrollController.position.ensureVisible(
          focusNode.context!.findRenderObject()!,
          alignment: 0.3, // Adjust alignment as needed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    editVehicleBloc.close();
  }

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
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: const AppBarWidget(
                title: "Edit Vehicle",
              ),
              body: bodySection(),
              bottomSheet: bottomSheetSection(),
            ),
          ),
          BlocListener<EditVehicleBloc, EditVehicleState>(
            listener: (context, state) {
              if (state is EditVehicleLoading) {
                isLoadingActive = true;
              } else {
                isLoadingActive = false;
              }
              setState(() {});
            },
            child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget bottomSheetSection() {
    return BlocConsumer<EditVehicleBloc, EditVehicleState>(
      listener: (context, state) {
        if (state is EditVehicleFailed) {
          AppDialogAction.showFailedPopup(
            context: context,
            title: 'Terjadi kesalahan',
            description: state.errorMessage,
            buttonTitle: 'Kembali',
          );
        }
        if (state is EditVehicleSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          AppDialogAction.showSuccessPopup(
            context: context,
            title: 'Berhasil mengubah data kendaraan',
            description: state.editVehicleResponseModel.message,
            buttonTitle: 'Kembali',
            barrierDismissible: false,
            mainButtonAction: () {
              context.read<GetAllVehicleBloc>().add(
                    GetAllVehicleRemoteAction(
                      reqData: GetAllVehicleRequestModelV2(
                        limit: 10,
                        currentPage: 1,
                      ),
                      action: GetAllVehicleActionEnum.refresh,
                    ),
                  );
              Get.offAll(() => const MainPage());
            },
          );
        }
      },
      builder: (context, state) {
        return AppBottomNavBarButtonWidget(
          title: "Update Vehicle",
          onTap: () {
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
        );
      },
    );
  }

  Widget bodySection() {
    return SingleChildScrollView(
      controller: _scrollController,
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
              focusNode: vehicleNameFocusNode,
              onTap: () {
                scrollToFocusedTextField(vehicleNameFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Year",
              textFieldHintText: "Year",
              controller: yearController,
              focusNode: yearFocusNode,
              keyboardType: TextInputType.number,
              onTap: () {
                scrollToFocusedTextField(yearFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Engine Capacity (cc)",
              textFieldHintText: "ex: 250",
              controller: engineCapacityController,
              focusNode: engineCapacityFocusNode,
              keyboardType: TextInputType.number,
              onTap: () {
                scrollToFocusedTextField(engineCapacityFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Tank Capacity (Litre)",
              textFieldHintText: "ex: 250",
              controller: tankCapacityController,
              focusNode: tankCapacityFocusNode,
              keyboardType: TextInputType.number,
              onTap: () {
                scrollToFocusedTextField(tankCapacityFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Color",
              textFieldHintText: "Color",
              controller: colorController,
              focusNode: colorFocusNode,
              onTap: () {
                scrollToFocusedTextField(colorFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Machine Number",
              textFieldHintText: "Machine Number",
              controller: machineNumberController,
              focusNode: machineNumberFocusNode,
              onTap: () {
                scrollToFocusedTextField(machineNumberFocusNode);
              },
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Chassis Number",
              textFieldHintText: "Chassis Number",
              controller: chassisNumberController,
              focusNode: chassisNumberFocusNode,
              onTap: () {
                scrollToFocusedTextField(chassisNumberFocusNode);
              },
            ),
            SizedBox(height: 20.h),
            SizedBox(height: kToolbarHeight + 30.h),
          ],
        ),
      ),
    );
  }
}
