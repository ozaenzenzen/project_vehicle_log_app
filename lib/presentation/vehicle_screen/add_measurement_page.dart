import 'package:fam_coding_supply/logic/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/dummy_data_service.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/create_log_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/add_measurement_page_type_enum.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_log_vehicle_bloc/create_log_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_tooltip_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class AddMeasurementPage extends StatefulWidget {
  final int vehicleId;
  final String? measurementService;
  final List<ListDatumLogEntity>? listLogVehicleData;
  final AddMeasurementPageActionTypeEnum actionType;

  const AddMeasurementPage({
    Key? key,
    required this.vehicleId,
  })  : measurementService = null,
        listLogVehicleData = null,
        actionType = AddMeasurementPageActionTypeEnum.newData,
        super(key: key);

  const AddMeasurementPage.continueData({
    Key? key,
    required this.vehicleId,
    this.measurementService,
    this.listLogVehicleData,
  })  : actionType = AddMeasurementPageActionTypeEnum.continueData,
        super(key: key);

  @override
  State<AddMeasurementPage> createState() => _AddMeasurementPageState();
}

class _AddMeasurementPageState extends State<AddMeasurementPage> {
  TextEditingController measurementTitleController = TextEditingController();
  TextEditingController currentOdoController = TextEditingController();
  TextEditingController estimateOdoController = TextEditingController();
  TextEditingController amountExpensesController = TextEditingController();
  TextEditingController checkpointDateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final measurementTitleTooltipController = SuperTooltipController();
  final currentOdoTooltipController = SuperTooltipController();
  final estimateOdoTooltipController = SuperTooltipController();
  final amountExpensesTooltipController = SuperTooltipController();
  final checkpointDateTooltipController = SuperTooltipController();
  final notesTooltipController = SuperTooltipController();

  final measurementTitleFocusNode = FocusNode();
  final currentOdoFocusNode = FocusNode();
  final estimateOdoFocusNode = FocusNode();
  final amountExpensesFocusNode = FocusNode();
  final checkpointDateFocusNode = FocusNode();
  final notesFocusNode = FocusNode();

  DateTime? checkpointDateChosen;

  final formatter = DateFormat('dd MMMM yyyy');

  bool isLoadingActive = false;

  bool isCurrentOdoMoreThanEstimateOdo = false;

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
  void initState() {
    super.initState();
    if (widget.measurementService != null) {
      measurementTitleController.text = widget.measurementService!;
      currentOdoController.text = widget.listLogVehicleData!.firstWhere((element) => element.measurementTitle == widget.measurementService).estimateOdoChanging!;
      // currentOdoController.text = widget.listLogVehicleData!.first.estimateOdoChanging!;
    }
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
              title: "Add Measurement",
            ),
            body: bodySection(context),
            bottomSheet: bottomSheetSection(),
            resizeToAvoidBottomInset: true,
          ),
        ),
        BlocListener<CreateLogVehicleBloc, CreateLogVehicleState>(
          listener: (context, state) {
            if (state is CreateLogVehicleLoading) {
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
    return BlocConsumer<CreateLogVehicleBloc, CreateLogVehicleState>(
      listener: (context, state) {
        if (state is CreateLogVehicleFailed) {
          AppDialogActionCS.showFailedPopup(
            context: context,
            title: "Terjadi kesalahan",
            description: state.errorMessage,
            buttonTitle: "Kembali",
          );
        } else if (state is CreateLogVehicleSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          AppDialogActionCS.showSuccessPopup(
            context: context,
            title: "Berhasil menambah log data kendaraan",
            description: state.createLogVehicleResponseModel.message!,
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
              Get.offAll(() => const MainPage());
            },
          );
        }
      },
      builder: (context, state) {
        return AppBottomNavBarButtonWidget(
          title: "Add Measurement",
          onTap: () {
            if (measurementTitleController.text.isEmpty ||
                currentOdoController.text.isEmpty ||
                estimateOdoController.text.isEmpty ||
                amountExpensesController.text.isEmpty ||
                checkpointDateController.text.isEmpty ||
                notesController.text.isEmpty) {
              AppDialogAction.showFailedPopup(
                context: context,
                title: "Error",
                description: "field can't be empty",
                buttonTitle: "Back",
              );
            } else if (isCurrentOdoMoreThanEstimateOdo) {
              AppDialogActionCS.showFailedPopup(
                context: context,
                title: "Error",
                description: "Tidak boleh kurang atau sama dengan dari Current Odo",
                buttonTitle: "Back",
              );
            } else {
              context.read<CreateLogVehicleBloc>().add(
                    CreateLogVehicleAction(
                      createLogVehicleRequestModel: CreateLogVehicleRequestModel(
                        // userId: accountDataUserModel!.userId!,
                        vehicleId: widget.vehicleId,
                        measurementTitle: measurementTitleController.text,
                        currentOdo: currentOdoController.text,
                        estimateOdoChanging: estimateOdoController.text,
                        amountExpenses: amountExpensesController.text,
                        checkpointDate: checkpointDateChosen!.toIso8601String(),
                        notes: notesController.text,
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
      child: Column(
        children: [
          SizedBox(height: 16.h),
          selectServiceSection(),
          SizedBox(height: 20.h),
          fieldSection(context),
        ],
      ),
    );
  }

  Widget fieldSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stats",
                style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.edit_square,
                size: 25.h,
                color: AppColor.primary,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: measurementTitleFocusNode,
            textFieldTitle: "Measurement Title",
            textFieldHintText: "ex: Oil",
            controller: measurementTitleController,
            readOnly: true,
            ignorePointerActive: true,
            action: widget.actionType == AddMeasurementPageActionTypeEnum.continueData
                ? [
                    AppTooltipWidget(
                      tooltipController: measurementTitleTooltipController,
                      message: "Data Anda sebelumnya yaitu: ${measurementTitleController.text}",
                      child: InkWell(
                        onTap: () {
                          measurementTitleTooltipController.showTooltip();
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 24.h,
                        ),
                      ),
                    ),
                  ]
                : null,
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: currentOdoFocusNode,
            textFieldTitle: "Current Odo (km)",
            textFieldHintText: "ex: 12000",
            controller: currentOdoController,
            keyboardType: TextInputType.number,
            error: Text(
              "Only number is allowed",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.error,
              ),
            ),
            errorChecker: (value, isError) {
              if (value.isNotEmpty) {
                if (RegExp(r'^\d+$').hasMatch(value)) {
                  return false;
                } else {
                  return true;
                }
              } else {
                return false;
              }
            },
            onTap: () {
              scrollToFocusedTextField(currentOdoFocusNode);
            },
            action: widget.actionType == AddMeasurementPageActionTypeEnum.continueData
                ? [
                    AppTooltipWidget(
                      tooltipController: currentOdoTooltipController,
                      message: "Data Anda sebelumnya: ${currentOdoController.text}",
                      child: InkWell(
                        onTap: () {
                          currentOdoTooltipController.showTooltip();
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 24.h,
                        ),
                      ),
                    ),
                  ]
                : null,
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: estimateOdoFocusNode,
            textFieldTitle: "Estimate Odo Changing (km)",
            textFieldHintText: "ex: 14000",
            controller: estimateOdoController,
            keyboardType: TextInputType.number,
            error: estimateOdoValidator(
                      currentOdoController,
                      estimateOdoController,
                    ) ==
                    null
                ? null
                : Text(
                    estimateOdoValidator(
                      currentOdoController,
                      estimateOdoController,
                    )!,
                    style: GoogleFonts.inter(
                      color: AppColor.red,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                  ),
            onChanged: (value) {
              setState(() {});
            },
            onTap: () {
              scrollToFocusedTextField(estimateOdoFocusNode);
            },
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: amountExpensesFocusNode,
            textFieldTitle: "Amount Expenses (Rp)",
            textFieldHintText: "ex: 40000",
            controller: amountExpensesController,
            keyboardType: TextInputType.number,
            onTap: () {
              scrollToFocusedTextField(amountExpensesFocusNode);
            },
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: checkpointDateFocusNode,
            textFieldTitle: "Checkpoint Date",
            textFieldHintText: formatter.format(DateTime.now()),
            controller: checkpointDateController,
            readOnly: true,
            suffixIcon: const Icon(Icons.date_range_sharp),
            action: widget.actionType == AddMeasurementPageActionTypeEnum.continueData
                ? [
                    AppTooltipWidget(
                      tooltipController: checkpointDateTooltipController,
                      message: "Data Anda sebelumnya: ${formatter.format(DateTime.parse(widget.listLogVehicleData!.first.checkpointDate!))}",
                      child: InkWell(
                        onTap: () {
                          checkpointDateTooltipController.showTooltip();
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 24.h,
                        ),
                      ),
                    ),
                  ]
                : null,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                debugPrint(pickedDate.toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                // String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                String formattedDate = formatter.format(pickedDate);
                checkpointDateChosen = pickedDate;
                debugPrint(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  checkpointDateController.text = formattedDate; //set output date to TextField value.
                });
              } else {
                debugPrint("Date is not selected");
              }
            },
          ),
          SizedBox(height: 15.h),
          AppTextFieldWidget(
            focusNode: notesFocusNode,
            textFieldTitle: "Notes",
            textFieldHintText: "notes",
            maxLines: 4,
            controller: notesController,
            onTap: () {
              scrollToFocusedTextField(notesFocusNode);
            },
          ),
          SizedBox(height: 25.h),
          SizedBox(height: kToolbarHeight + 30.h),
        ],
      ),
    );
  }

  Widget selectServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Service",
                style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "Add Other Service",
                  style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                    color: AppColor.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: MeasurementServiceDummyData.dummyDataService.length,
            separatorBuilder: (context, index) {
              return SizedBox(width: 10.h);
            },
            itemBuilder: (context, index) {
              return Container(
                padding: (index == 0) ? EdgeInsets.only(left: 16.w) : null,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      measurementTitleController.text = MeasurementServiceDummyData.dummyDataService[index].title!;
                      //   debugPrint("test hit $index");
                      //   indexClicked = index;
                      //   vehicleListColor = AppColor.white;
                    });
                  },
                  child: Container(
                    width: 100.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.h,
                    ),
                    decoration: BoxDecoration(
                      // color: index == indexClicked ? AppColor.primary : Colors.transparent,
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor.blue,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          // Icons.time_to_leave_rounded,
                          MeasurementServiceDummyData.dummyDataService[index].icons,
                          color: AppColor.blue,
                        ),
                        Text(
                          // "${DummyData.dummyData[index].vehicleName}",
                          // "Menu $index",
                          "${MeasurementServiceDummyData.dummyDataService[index].title}",
                          textAlign: TextAlign.center,
                          // overflow: TextOverflow.ellipsis,
                          style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
                            // color: AppColor.text_4,
                            // color: Colors.black38,
                            color: AppColor.blue,
                            // color: index == indexClicked ? AppColor.white : Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String? estimateOdoValidator(TextEditingController currentOdoCtrl, TextEditingController estimateOdoCtrl) {
    if (currentOdoCtrl.text.isNotEmpty && estimateOdoCtrl.text.isNotEmpty) {
      double currentOdo = double.parse(currentOdoCtrl.text);
      double estimateOdo = double.parse(estimateOdoCtrl.text);
      if (estimateOdo <= currentOdo) {
        isCurrentOdoMoreThanEstimateOdo = true;
        return "Tidak boleh kurang atau sama dengan dari Current Odo";
      } else {
        isCurrentOdoMoreThanEstimateOdo = false;
        return null;
      }
    } else {
      isCurrentOdoMoreThanEstimateOdo = false;
      return null;
    }
  }
}
