import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_v2_bloc/get_all_vehicle_v2_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/home_page_version2.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_page.dart';
import 'package:project_vehicle_log_app/presentation/stats_screen/stats_page_version2.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/add_vehicle_page.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_page_version2.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_custom_appbar.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexClicked = 0;
  Color vehicleListColor = Colors.black38;

  PageController pageController = PageController(
    initialPage: 0,
  );

  void _selectedTab(int index) {
    // debugPrint("index masuk $index");
    if (index == 0) {
      indexClicked = 0;
      pageController.jumpToPage(
        0,
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.ease,
      );
    } else if (index == 1) {
      indexClicked = 1;
      pageController.jumpToPage(
        1,
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.ease,
      );
    } else if (index == 2) {
      indexClicked = 2;
      pageController.jumpToPage(
        2,
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.ease,
      );
    } else {
      Get.to(() => const ProfilePage());
    }
  }

  @override
  void initState() {
    super.initState();
    context
      ..read<ProfileBloc>().add(
        GetProfileRemoteAction(
          accountRepository: AppAccountReposistory(),
        ),
      )
      ..read<GetAllVehicleV2Bloc>().add(
        GetAllVehicleV2LocalAction(
          reqData: GetAllVehicleRequestModelV2(
            limit: 10,
            currentPage: 1,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(() => const AddVehiclePage());
        },
        backgroundColor: AppColor.primary,
        elevation: 0,
        child: Icon(
          Icons.add_circle_outline_outlined,
          color: AppColor.white,
          size: 35.h,
        ),
      ),
      bottomNavigationBar: AppCustomAppBar(
        centerItemText: 'Add Vehicle',
        color: AppColor.white,
        selectedColor: AppColor.white,
        notchedShape: const CircularNotchedRectangle(),
        onTabSelected: (index) {
          _selectedTab(index);
        },
        backgroundColor: AppColor.primary,
        iconSize: 25.h,
        fontSize: 10.sp,
        height: 80.h,
        currentIndex: indexClicked,
        items: [
          AppCustomAppBarItem(
            iconData: Icons.home,
            text: "Home",
          ),
          AppCustomAppBarItem(
            iconData: Icons.motorcycle,
            text: "Vehicle",
          ),
          AppCustomAppBarItem(
            iconData: Icons.bar_chart,
            text: "Stats",
          ),
          AppCustomAppBarItem(
            iconData: Icons.person,
            text: "Profile",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (currentPage) {
          // debugPrint("page now: $currentPage");
          setState(() {
            indexClicked = currentPage;
          });
          // setState(() {
          //   _selectedTab(currentPage);
          // });
        },
        children: const [
          // HomePage(),
          HomePageVersion2(),
          VehiclePageVersion2(),
          StatsPageVersion2(),
        ],
      ),
    );
  }
}
