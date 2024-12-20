import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/create_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_vehicle_bloc/create_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_tooltip_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_image_picker.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({Key? key}) : super(key: key);

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  String? imagePickedInBase64 = "";
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController engineCapacityController = TextEditingController();
  TextEditingController tankCapacityController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController machineNumberController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();

  var vehicleNameFocusNode = FocusNode();
  var yearFocusNode = FocusNode();
  var engineCapacityFocusNode = FocusNode();
  var tankCapacityFocusNode = FocusNode();
  var colorFocusNode = FocusNode();
  var machineNumberFocusNode = FocusNode();
  var chassisNumberFocusNode = FocusNode();

  var vehicleNameGlobalKey = GlobalKey();
  var yearGlobalKey = GlobalKey();
  var engineCapacityGlobalKey = GlobalKey();
  var tankCapacityGlobalKey = GlobalKey();
  var colorGlobalKey = GlobalKey();
  var machineNumberGlobalKey = GlobalKey();
  var chassisNumberGlobalKey = GlobalKey();

  final tooltipController = SuperTooltipController();

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

  void scrollToFocusedTextFieldOld() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent - 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> ensureVisibleOnTextArea({
    required GlobalKey textfieldKey,
  }) async {
    final keyContext = textfieldKey.currentContext;
    if (keyContext != null) {
      await Future.delayed(const Duration(milliseconds: 300)).then(
        (value) => Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: const AppBarWidget(
              title: "Add Vehicle",
            ),
            body: bodySection(context),
            bottomSheet: bottomSheetSection(),
            resizeToAvoidBottomInset: true,
          ),
        ),
        BlocListener<CreateVehicleBloc, CreateVehicleState>(
          listener: (context, state) {
            if (state is CreateVehicleLoading) {
              isLoadingActive = true;
            } else {
              isLoadingActive = false;
            }
            setState(() {});
          },
          child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
        ),
      ],
    );
  }

  Widget bottomSheetSection() {
    return BlocConsumer<CreateVehicleBloc, CreateVehicleState>(
      listener: (context, state) {
        if (state is CreateVehicleFailed) {
          AppDialogAction.showFailedPopup(
            context: context,
            title: "Terjadi kesalahan",
            description: state.errorMessage,
            buttonTitle: "Kembali",
          );
        }
        if (state is CreateVehicleSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          AppDialogAction.showSuccessPopup(
            context: context,
            title: "Berhasil menambahkan kendaraan",
            description: state.createVehicleResponseModel.message,
            buttonTitle: "Kembali",
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
              Get.off(() => const MainPage());
            },
          );
        }
      },
      builder: (context, state) {
        return AppBottomNavBarButtonWidget(
          title: "Add Vehicle",
          onTap: () {
            if (vehicleNameController.text.isEmpty ||
                imagePickedInBase64 == "" ||
                imagePickedInBase64 == null ||
                yearController.text.isEmpty ||
                engineCapacityController.text.isEmpty ||
                tankCapacityController.text.isEmpty ||
                colorController.text.isEmpty ||
                machineNumberController.text.isEmpty ||
                chassisNumberController.text.isEmpty) {
              AppDialogAction.showFailedPopup(
                context: context,
                title: "Error",
                description: "field can't be empty",
                buttonTitle: "Back",
              );
            } else {
              context.read<CreateVehicleBloc>().add(
                    CreateVehicleAction(
                      createVehicleRequestModel: CreateVehicleRequestModel(
                        // userId: accountDataUserModel!.userId!,
                        vehicleName: vehicleNameController.text,
                        vehicleImage: imagePickedInBase64!,
                        year: yearController.text,
                        engineCapacity: engineCapacityController.text,
                        tankCapacity: tankCapacityController.text,
                        color: colorController.text,
                        machineNumber: machineNumberController.text,
                        chassisNumber: chassisNumberController.text,
                      ),
                    ),
                  );
            }
          },
        );
      },
    );
  }

  Widget bodySection(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ScrollPhysics(),
      padding: EdgeInsets.only(
        top: 16.h,
        left: 16.h,
        right: 16.h,
        bottom: 16.h,
        // bottom: MediaQuery.of(context).viewInsets.bottom + 100,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Vehicle",
              style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Add your vehicle alongside with measurement parameter",
              style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vehicle Image",
                  style: GoogleFonts.inter(
                    color: const Color(0xff331814),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppTooltipWidget(
                  tooltipController: tooltipController,
                  message: "Kami mereduksi ukuran gambar yang Anda pilih untuk pengalaman yang lebih baik",
                  child: InkWell(
                    onTap: () {
                      // tooltip();
                      tooltipController.showTooltip();
                    },
                    child: Icon(
                      Icons.info_outline,
                      size: 24.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () async {
                imagePickedInBase64 = await AppImagePickerService().getImageAsBase64().then(
                  (value) {
                    setState(() {});
                    return value;
                  },
                );
              },
              child: (imagePickedInBase64 == "" || imagePickedInBase64 == null)
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
                                // borderRadius: BorderRadius.only(
                                //   topLeft: Radius.circular(8.h),
                                //   topRight: Radius.circular(8.h),
                                // ),
                                child: Image.memory(
                                  base64Decode(base64.normalize(imagePickedInBase64!)),
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
              key: vehicleNameGlobalKey,
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
              key: yearGlobalKey,
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
              textFieldHintText: "ex: 4.0",
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
            SizedBox(height: kToolbarHeight + 30.h),
          ],
        ),
      ),
    );
  }
}
