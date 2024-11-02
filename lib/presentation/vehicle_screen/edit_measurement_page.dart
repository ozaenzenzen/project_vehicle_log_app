import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/init_config.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/edit_measurement_log_bloc/edit_measurement_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class EditMeasurementPage extends StatefulWidget {
  final ListDatumLogEntity data;

  const EditMeasurementPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditMeasurementPage> createState() => _EditMeasurementPageState();
}

class _EditMeasurementPageState extends State<EditMeasurementPage> {
  TextEditingController checkpointDateController = TextEditingController();
  TextEditingController measurementTitleController = TextEditingController();
  TextEditingController currentOdoController = TextEditingController();
  TextEditingController estimateOdoChangingController = TextEditingController();
  TextEditingController amountExpensesController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  late EditMeasurementLogBloc editMeasurementLogBloc;

  DateTime? checkpointDateChosen;

  final DateFormat formattedDate = DateFormat('dd MMMM yyyy');

  bool isLoadingActive = false;

  @override
  void dispose() {
    super.dispose();
    editMeasurementLogBloc.close();
  }

  @override
  void initState() {
    editMeasurementLogBloc = EditMeasurementLogBloc(AppVehicleReposistory(AppInitConfig.appInterceptors.appApiService));

    measurementTitleController.text = widget.data.measurementTitle ?? "";
    currentOdoController.text = widget.data.currentOdo ?? "";
    estimateOdoChangingController.text = widget.data.estimateOdoChanging ?? "";
    amountExpensesController.text = widget.data.amountExpenses ?? "";

    checkpointDateChosen = DateTime.parse(widget.data.checkpointDate.toString()).toLocal();
    // checkpointDateController.text = widget.data.checkpointDate ?? "";
    checkpointDateController.text = formattedDate.format(checkpointDateChosen!);
    // AppLogger.debugLog("value: ${checkpointDateChosen?.toLocal()}");

    notesController.text = widget.data.notes ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editMeasurementLogBloc,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: const AppBarWidget(
                title: "Edit Measurement",
              ),
              body: bodySection(),
              bottomSheet: bottomSheetSection(),
            ),
          ),
          BlocListener<EditMeasurementLogBloc, EditMeasurementLogState>(
            listener: (context, state) {
              if (state is EditMeasurementLogLoading) {
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
    return BlocConsumer<EditMeasurementLogBloc, EditMeasurementLogState>(
      listener: (context, state) {
        if (state is EditMeasurementLogFailed) {
          AppDialogAction.showFailedPopup(
            context: context,
            title: "Terjadi Kesalahan",
            description: state.errorMessage,
            buttonTitle: "Kembali",
          );
        }
        if (state is EditMeasurementLogSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          AppDialogAction.showSuccessPopup(
            context: context,
            title: "Berhasil mengubah log data kendaraan",
            description: state.editMeasurementLogResponseModel.message,
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
          title: "Update Measurement",
          onTap: () {
            editMeasurementLogBloc.add(
              UpdateMeasurementAction(
                editMeasurementLogRequestModel: EditMeasurementLogRequestModel(
                  id: widget.data.id,
                  vehicleId: widget.data.vehicleId,
                  measurementTitle: measurementTitleController.text,
                  currentOdo: currentOdoController.text,
                  estimateOdoChanging: estimateOdoChangingController.text,
                  amountExpenses: amountExpensesController.text,
                  // checkpointDate: checkpointDateController.text,
                  checkpointDate: "${checkpointDateChosen?.toIso8601String()}",
                  notes: notesController.text,
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
      child: Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
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
            IgnorePointer(
              child: AppTextFieldWidget(
                textFieldTitle: "Measurement Title",
                textFieldHintText: "ex: Oil",
                controller: measurementTitleController,
                readOnly: true,
              ),
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Current Odo (km)",
              textFieldHintText: "ex: 12000",
              controller: currentOdoController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Estimate Odo Changing (km)",
              textFieldHintText: "ex: 14000",
              controller: estimateOdoChangingController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Amount Expenses (Rp)",
              textFieldHintText: "ex: 40000",
              controller: amountExpensesController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Checkpoint Date",
              textFieldHintText: "12-2-2023",
              controller: checkpointDateController,
              readOnly: true,
              suffixIcon: const Icon(Icons.date_range_sharp),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  debugPrint(pickedDate.toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  debugPrint(formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement
                  checkpointDateChosen = pickedDate;

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
              textFieldTitle: "Notes",
              textFieldHintText: "notes",
              controller: notesController,
            ),
            SizedBox(height: 25.h),
            SizedBox(height: kToolbarHeight + 30.h),
          ],
        ),
      ),
    );
  }
}
