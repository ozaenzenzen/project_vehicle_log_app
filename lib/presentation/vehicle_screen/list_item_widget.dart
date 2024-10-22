import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/enum/status_logs_enum.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class ItemListWidget extends StatefulWidget {
  final String? title;
  final StatusLogs? statusLogs;
  final String? value;
  final ListDatumLogEntity? vehicleMeasurementLogModels;

  const ItemListWidget({
    Key? key,
    required this.title,
    required this.value,
  })  : statusLogs = null,
        vehicleMeasurementLogModels = null,
        super(key: key);

  const ItemListWidget.logs({
    Key? key,
    required this.title,
    required this.statusLogs,
    required this.vehicleMeasurementLogModels,
  })  : value = null,
        super(key: key);

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  final formatter = DateFormat('dd MMMM yyyy, HH:mm:ss');
  Color statusColor = Colors.black;
  String statusTitle = "Add";

  void handleStatus(statusLogs) {
    if (statusLogs == StatusLogs.add) {
      statusColor = AppColor.green;
      statusTitle = "Add";
    } else if (statusLogs == StatusLogs.update) {
      statusColor = AppColor.yellow;
      statusTitle = "Update";
    } else {
      statusColor = AppColor.red;
      statusTitle = "Delete";
    }
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    handleStatus(widget.statusLogs);
    if (widget.statusLogs == null) {
      return Container(
        height: 40.h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        decoration: BoxDecoration(
          color: AppColor.border,
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title!,
              style: AppTheme.theme.textTheme.bodyLarge?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.value!,
              style: AppTheme.theme.textTheme.bodyLarge?.copyWith(
                // color: AppColor.text_4,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: AppTheme.theme.textTheme.displaySmall?.copyWith(
                      // color: AppColor.text_4,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    // "(${widget.statusLogs.toString()})",
                    "(${statusTitle.toString()})",
                    style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                      // color: AppColor.text_4,
                      // color: Colors.black,
                      // color: handleStatusColor(widget.statusLogs),
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(widget.vehicleMeasurementLogModels!.createdAt!.toLocal()),
                      style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      convertToAgo(widget.vehicleMeasurementLogModels!.createdAt!.toLocal()),
                      style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                        // color: AppColor.text_4,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.w),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      "New Odo",
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      widget.vehicleMeasurementLogModels!.estimateOdoChanging!,
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      "Date Updated",
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      formatter.format(widget.vehicleMeasurementLogModels!.updatedAt!),
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      "Amount",
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      widget.vehicleMeasurementLogModels!.amountExpenses!,
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      "Notes",
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      widget.vehicleMeasurementLogModels!.notes!,
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        // color: AppColor.text_4,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
