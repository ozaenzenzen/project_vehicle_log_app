import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/edit_measurement_log_bloc/edit_measurement_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_secondarybutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class EditMeasurementPage extends StatefulWidget {
  final VehicleMeasurementLogModel data;

  const EditMeasurementPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditMeasurementPage> createState() => _EditMeasurementPageState();
}

class _EditMeasurementPageState extends State<EditMeasurementPage> {
  // final DateFormat formattedDate = DateFormat('yyyy-MM-dd');
  final DateFormat formattedDate = DateFormat('dd MMMM yyyy');

  TextEditingController checkpointDateController = TextEditingController();

  TextEditingController measurementTitleController = TextEditingController();
  TextEditingController currentOdoController = TextEditingController();
  TextEditingController estimateOdoChangingController = TextEditingController();
  TextEditingController amountExpensesController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  late EditMeasurementLogBloc editMeasurementLogBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    editMeasurementLogBloc = EditMeasurementLogBloc();
  }

  @override
  void dispose() {
    super.dispose();
    editMeasurementLogBloc.close();
    debugPrint('disposed');
  }

  @override
  void initState() {
    measurementTitleController.text = widget.data.measurementTitle ?? "";
    currentOdoController.text = widget.data.currentOdo ?? "";
    estimateOdoChangingController.text = widget.data.estimateOdoChanging ?? "";
    amountExpensesController.text = widget.data.amountExpenses ?? "";
    checkpointDateController.text = widget.data.checkpointDate ?? "";
    notesController.text = widget.data.notes ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editMeasurementLogBloc,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: const AppBarWidget(
            title: "Edit Measurement",
          ),
          body: Stack(
            children: [
              formView(),
              BlocBuilder<EditMeasurementLogBloc, EditMeasurementLogState>(
                builder: (context, state) {
                  if (state is EditMeasurementLogLoading) {
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
    );
  }

  Widget formView() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            // SizedBox(height: 20.h),
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
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Estimate Odo Changing (km)",
              textFieldHintText: "ex: 14000",
              controller: estimateOdoChangingController,
            ),
            SizedBox(height: 15.h),
            AppTextFieldWidget(
              textFieldTitle: "Amount Expenses (Rp)",
              textFieldHintText: "ex: 40000",
              controller: amountExpensesController,
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
            BlocListener<EditMeasurementLogBloc, EditMeasurementLogState>(
              listener: (context, state) {
                if (state is EditMeasurementLogFailed) {
                  AppDialogAction.showFailedPopup(
                    context: context,
                    title: "Terjadi Kesalahan",
                    description: state.errorMessage,
                    buttonTitle: "Kembali",
                    mainButtonAction: () {
                      Get.back();
                    },
                  );
                } else if (state is EditMeasurementLogSuccess) {
                  AppDialogAction.showSuccessPopup(
                    context: context,
                    title: "Berhasil",
                    description: state.editMeasurementLogResponseModel.message,
                    buttonTitle: "Kembali",
                    mainButtonAction: () {
                      Get.offAll(const MainPage());
                    },
                  );
                }
              },
              child: AppMainButtonWidget(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  editMeasurementLogBloc.add(
                        UpdateMeasurementAction(
                          editMeasurementLogRequestModel: EditMeasurementLogRequestModel(
                            id: widget.data.id,
                            vehicleId: widget.data.vehicleId,
                            measurementTitle: measurementTitleController.text,
                            currentOdo: currentOdoController.text,
                            estimateOdoChanging: estimateOdoChangingController.text,
                            amountExpenses: amountExpensesController.text,
                            checkpointDate: checkpointDateController.text,
                            notes: notesController.text,
                          ),
                        ),
                      );
                },
                text: "Update",
              ),
            ),
            SizedBox(height: 10.h),
            AppSecondaryButtonWidget.error(
              onPressed: () {
                Get.back();
              },
              text: "Delete",
            ),
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
