// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
// import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
// 
// import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
// import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
// import 'package:project_vehicle_log_app/support/app_assets.dart';
// import 'package:project_vehicle_log_app/support/app_color.dart';
// import 'package:project_vehicle_log_app/support/app_theme.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:project_vehicle_log_app/presentation/vehicle_screen/edit_main_info_page.dart';
// import 'package:project_vehicle_log_app/presentation/vehicle_screen/list_item_widget.dart';
// import 'package:project_vehicle_log_app/presentation/vehicle_screen/add_measurement_page.dart';
// import 'package:project_vehicle_log_app/presentation/vehicle_screen/dvp_stats_item_widget.dart';

// enum StatusLogs { add, update, delete }

// class DetailVehiclePage extends StatefulWidget {
//   final int index;
//   final DatumVehicle datumVehicle;

//   const DetailVehiclePage({
//     Key? key,
//     required this.index,
//     required this.datumVehicle,
//   }) : super(key: key);

//   @override
//   State<DetailVehiclePage> createState() => _DetailVehiclePageState();
// }

// class _DetailVehiclePageState extends State<DetailVehiclePage> with TickerProviderStateMixin {
//   late TabController tabController;

//   TooltipBehavior? tooltipBehavior;

//   late GetAllVehicleBloc getAllVehicleBloc;

//   List<VehicleMeasurementLogModel> sortedListLogs = [];

//   @override
//   void initState() {
//     super.initState();
//     getAllVehicleBloc = BlocProvider.of(context)
//       ..add(
//         GetAllVehicleDataLocalAction(
//           vehicleLocalRepository: VehicleLocalRepository(),
//         ),
//       );
//     tooltipBehavior = TooltipBehavior(enable: true);
//     tabController = TabController(
//       vsync: this,
//       length: 3,
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     getAllVehicleBloc = BlocProvider.of(context)
//       ..add(
//         GetAllVehicleDataLocalAction(
//           vehicleLocalRepository: VehicleLocalRepository(),
//         ),
//       );
//     super.didChangeDependencies();
//   }

//   TabBar get _tabBar => TabBar(
//         // unselectedLabelColor: AppColor.disabled,
//         controller: tabController,
//         tabs: const [
//           Tab(
//             text: "Info",
//             icon: Icon(Icons.info),
//           ),
//           Tab(
//             text: "Logs",
//             icon: Icon(Icons.list_rounded),
//           ),
//           Tab(
//             text: "Stats",
//             icon: Icon(Icons.legend_toggle_sharp),
//           ),
//         ],
//       );

//   infoView() {
//     return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
//       bloc: getAllVehicleBloc,
//       builder: (context, state) {
//         if (state is GetAllVehicleLoading) {
//           return const AppLoadingIndicator();
//         } else if (state is GetAllVehicleFailed) {
//           return Text(state.errorMessage);
//         } else if (state is GetAllVehicleSuccess) {
//           return SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.all(16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     // "Name Vehicle",
//                     state.getAllVehicleDataResponseModel!.data![widget.index].vehicleName!,
//                     style: AppTheme.theme.textTheme.displayLarge?.copyWith(
//                       // color: AppColor.text_4,
//                       color: Colors.black38,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   (state.getAllVehicleDataResponseModel!.data![widget.index].vehicleImage! == 'x')
//                       ? Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw")
//                       : SizedBox(
//                           // child: Image.network("https://media.istockphoto.com/id/1096052566/vector/stamprsimp2red.jpg?s=612x612&w=0&k=20&c=KVu0nVz7ZLbZsRsx81VBZcuXZ1MlEmLk9IQabO2GkYo="),
//                           // child: Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw"),
//                           child: Image.memory(
//                             base64Decode(
//                               state.getAllVehicleDataResponseModel!.data![widget.index].vehicleImage!,
//                             ),
//                             height: 200.h,
//                             width: MediaQuery.of(context).size.width,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Image.network("https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw");
//                             },
//                           ),
//                         ),
//                   SizedBox(height: 10.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Main Info",
//                         style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Get.to(
//                             () => EditMainInfoPage(
//                               data: state.getAllVehicleDataResponseModel!.data![widget.index],
//                               index: widget.index,
//                             ),
//                           );
//                         },
//                         child: Icon(
//                           Icons.edit_square,
//                           size: 25.h,
//                           color: AppColor.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Year",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].year,
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Engine Capacity (cc)",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].engineCapacity,
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Tank Capacity (Litre)",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].tankCapacity,
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Color",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].color,
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Machine Number",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].machineNumber,
//                   ),
//                   SizedBox(height: 10.h),
//                   ItemListWidget(
//                     title: "Chassis Number",
//                     value: state.getAllVehicleDataResponseModel!.data![widget.index].chassisNumber,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return const Text("data is null");
//         }
//       },
//     );
//   }

//   logsView() {
//     return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
//       bloc: getAllVehicleBloc,
//       builder: (context, state) {
//         if (state is GetAllVehicleLoading) {
//           return const AppLoadingIndicator();
//         } else if (state is GetAllVehicleFailed) {
//           return Text(state.errorMessage);
//         } else if (state is GetAllVehicleSuccess) {
//           sortedListLogs = state.getAllVehicleDataResponseModel!.data![widget.index].vehicleMeasurementLogModels!;
//           sortedListLogs.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
//           return SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.all(16.h),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Logs",
//                         style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                   sortedListLogs.isEmpty
//                       ? newEmptyState(
//                         title: "Anda belum melakukan perubahan",
//                       )
//                       : ListView.separated(
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           // itemCount: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels.length,
//                           itemCount: sortedListLogs.length,
//                           itemBuilder: (context, index) {
//                             return ItemListWidget.logs(
//                               // title: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels[index].measurementTitle,
//                               title: sortedListLogs[index].measurementTitle,
//                               statusLogs: StatusLogs.add,
//                               // vehicleMeasurementLogModels: state.getAllVehicleDataResponseModel.data![widget.index].vehicleMeasurementLogModels[index],
//                               vehicleMeasurementLogModels: sortedListLogs[index],
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(height: 10.h);
//                           },
//                         ),
//                   // SizedBox(height: 5.h),
//                   // Center(
//                   //   child: Text(
//                   //     "See more",
//                   //     style: AppTheme.theme.textTheme.titleLarge?.copyWith(
//                   //       decoration: TextDecoration.underline,
//                   //       color: AppColor.blue,
//                   //       fontWeight: FontWeight.w600,
//                   //     ),
//                   //   ),
//                   // ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return const Text("data is null");
//         }
//       },
//     );
//   }

//   statsView() {
//     return BlocBuilder<GetAllVehicleBloc, GetAllVehicleState>(
//       builder: (context, state) {
//         if (state is GetAllVehicleLoading) {
//           return const AppLoadingIndicator();
//         } else if (state is GetAllVehicleFailed) {
//           return Text(state.errorMessage);
//         } else if (state is GetAllVehicleSuccess) {
//           return SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.all(16.h),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Stats",
//                         style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                   state.getAllVehicleDataResponseModel!.data![widget.index].categorizedData!.isEmpty
//                       ? newEmptyState(
//                           title: "Anda belum menambahkan pengukuran",
//                         )
//                       : ListView.separated(
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: state.getAllVehicleDataResponseModel!.data![widget.index].categorizedData!.length,
//                           itemBuilder: (context, index) {
//                             return DVPStatsItemWidget(
//                               title: state.getAllVehicleDataResponseModel!.data![widget.index].categorizedData![index].measurementTitle,
//                               data: state.getAllVehicleDataResponseModel!.data![widget.index].categorizedData![index],
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(height: 10.h);
//                           },
//                         ),
//                   // const DVPStatsItemWidget(
//                   //   title: "Oil",
//                   // ),
//                   // SizedBox(height: 10.h),
//                   // const DVPStatsItemWidget(
//                   //   title: "Radiator",
//                   // ),
//                   // SizedBox(height: 10.h),
//                   // const DVPStatsItemWidget(
//                   //   title: "Side Oil",
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return const Text("data is null");
//         }
//       },
//     );
//   }

//   Widget emptyState() {
//     return SizedBox(
//       height: 250.h,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "You haven't yet set measurement",
//             style: AppTheme.theme.textTheme.bodyLarge?.copyWith(
//               // color: AppColor.text_4,
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 10.h),
//           AppMainButtonWidget(
//             onPressed: () {
//               Get.to(() => AddMeasurementPage(
//                     vehicleId: widget.datumVehicle.id!,
//                   ));
//             },
//             text: "Add Now",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget newEmptyState({
//     required String title,
//   }) {
//     return Column(
//       children: [
//         SizedBox(height: 100.h),
//         Image.asset(
//           AppAssets.imgEmptyStateBlue,
//           height: 200.h,
//         ),
//         SizedBox(height: 12.h),
//         Text(
//           title,
//           style: GoogleFonts.inter(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 18.sp,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.shape,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Get.to(
//             () => AddMeasurementPage(
//               vehicleId: widget.datumVehicle.id!,
//             ),
//           );
//         },
//         label: Text(
//           "Add Measurement",
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: 14.sp,
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: AppColor.primary,
//         elevation: 10,
//         shadowColor: const Color(0xff101828),
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         title: Text(
//           "Detail Vehicle Page",
//           textAlign: TextAlign.left,
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 18.sp,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: _tabBar.preferredSize,
//           child: _tabBar,
//         ),
//       ),
//       body: TabBarView(
//         controller: tabController,
//         children: [
//           infoView(),
//           logsView(),
//           statsView(),
//         ],
//       ),
//     );
//   }
// }
