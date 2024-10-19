import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_request_model.dart';
import 'package:project_vehicle_log_app/data/repository/notification_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/notification/notification_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/notification_screen/notification_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/notification_screen/notification_bloc/notification_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(
          GetNotificationAction(
            appNotificationRepository: AppNotificationRepository(),
            requestData: GetNotificationRequestModel(
              limit: 10,
              currentPage: 1,
            ),
          ),
        );
  }

  final formatter = DateFormat('dd MMMM yyyy, HH:mm');

  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<GetNotificationEntity> listData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Notification",
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () {
          context.read<NotificationBloc>().add(
                GetNotificationAction(
                  appNotificationRepository: AppNotificationRepository(),
                  requestData: GetNotificationRequestModel(
                    limit: 10,
                    currentPage: 1,
                  ),
                  type: NotificationActionEnum.refresh,
                ),
              );
        },
        onLoading: () {
          context.read<NotificationBloc>().add(
                GetNotificationAction(
                  appNotificationRepository: AppNotificationRepository(),
                  requestData: GetNotificationRequestModel(
                    limit: 10,
                    currentPage: 1,
                  ),
                  type: NotificationActionEnum.loadMore,
                ),
              );
        },
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationSuccess) {
              if (state.type == NotificationActionEnum.refresh) {
                refreshController.refreshCompleted();
              } else {
                refreshController.loadComplete();
              }
            }
          },
          builder: (context, state) {
            if (state is NotificationLoading) {
              if (state.type == NotificationActionEnum.refresh) {
                return loadingSkeletonState();
              }
            }
            // if (state is NotificationFailed) {
            //   return Center(
            //     child: Text('terjadi kesalahan ${state.errorMessage}'),
            //   );
            // }
            if (state is NotificationSuccess) {
              listData = state.result.listData!;
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notification: ${listData.length}",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // itemCount: state.result.listData != null ? state.result.listData!.length : 0,
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColor.blue.withOpacity(0.1),
                          border: Border.all(
                            color: AppColor.blue,
                          ),
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notifications,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listData[index].notificationTitle!,
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        listData[index].notificationDescription!,
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                formatter.format(listData[index].updatedAt!.toLocal()),
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12.h);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loadingCircularState() {
    return Center(
      child: SizedBox(
        height: 50.h,
        width: 50.h,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget loadingSkeletonState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Notification: ",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 24.h,
                  width: 50.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 18,
            itemBuilder: (context, index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(height: 90.h, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(12)),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10.h);
            },
          ),
        ],
      ),
    );
  }
}
