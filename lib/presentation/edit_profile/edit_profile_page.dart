// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/init_config_v2.dart';
import 'package:project_vehicle_log_app/presentation/edit_profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  final Function()? callbackAction;

  const EditProfilePage({
    Key? key,
    this.callbackAction,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String profilePicture = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late ProfileBloc profileBloc;

  bool seeImage = false;

  @override
  void dispose() {
    super.dispose();
    profileBloc.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileBloc = ProfileBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService), AccountLocalRepository());
    profileBloc = profileBloc..add(GetProfileRemoteAction());
  }

  bool isLoadingActive = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => profileBloc,
      child: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              widget.callbackAction?.call();
              return true;
            },
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: AppColor.white,
                appBar: AppBarWidget(
                  title: 'Edit Profile',
                  onBack: () {
                    Get.back();
                    widget.callbackAction?.call();
                  },
                ),
                body: bodySection(),
                bottomSheet: bottomSheetSection(),
              ),
            ),
          ),
          if (seeImage)
            Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Dismissible(
                      key: const Key("value"),
                      direction: DismissDirection.vertical,
                      confirmDismiss: (direction) async {
                        setState(() {
                          seeImage = false;
                        });
                        return false;
                      },
                      onDismissed: (direction) {
                        debugPrint("direction $direction");
                      },
                      child: Image.memory(
                        base64Decode(profilePicture),
                        height: 300.h,
                        width: 300.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        setState(() {
                          seeImage = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4.h,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          MultiBlocListener(
            listeners: [
              BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoading) {
                    isLoadingActive = true;
                  } else {
                    isLoadingActive = false;
                  }
                  setState(() {});
                },
              ),
              BlocListener<EditProfileBloc, EditProfileState>(
                listener: (context, state) {
                  if (state is EditProfileLoading) {
                    isLoadingActive = true;
                  } else {
                    isLoadingActive = false;
                  }
                  setState(() {});
                },
              ),
            ],
            child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget bottomSheetSection() {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileFailed) {
          AppDialogActionCS.showFailedPopup(
            context: context,
            title: "Terjadi Kesalahan",
            description: "${state.errorMessage}",
            buttonTitle: "Kembali",
          );
        } else if (state is EditProfileSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          AppDialogActionCS.showSuccessPopup(
            context: context,
            title: "Berhasil",
            description: "${state.editProfileResponseModel.message}",
            buttonTitle: "Kembali",
          );
        }
      },
      builder: (context, state) {
        return AppBottomNavBarButtonWidget(
          title: 'Update Profile',
          onTap: () {
            if (state is EditProfileLoading || state is ProfileLoading) {
              AppDialogActionCS.showFailedPopup(
                context: context,
                title: 'Terjadi kesalahan',
                description: 'Mohon tunggu sebentar, masih mengambil data',
                buttonTitle: 'Kembali',
              );
            } else {
              context.read<EditProfileBloc>().add(
                    EditProfileAction(
                      editProfileRequestModel: EditProfileRequestModel(
                        profilePicture: profilePicture,
                        name: nameController.text,
                      ),
                    ),
                  );
            }
          },
        );
      },
    );
  }

  Widget bodySection() {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          profilePicture = state.userDataModel.profilePicture ?? "";
          nameController.text = state.userDataModel.name ?? "";
          emailController.text = state.userDataModel.email ?? "";
          phoneController.text = state.userDataModel.phone ?? "";
          setState(() {});
        }
      },
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.white,
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 25.h),
              InkWell(
                onTap: () async {
                  await chooseImageAction();
                },
                child: Stack(
                  children: [
                    (profilePicture != "" && profilePicture.length > 30)
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(profilePicture),
                              height: 120.h,
                              width: 120.h,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60.h,
                            backgroundColor: AppColor.primary,
                          ),
                    Positioned(
                      right: 10.h,
                      bottom: 10.h,
                      child: Icon(
                        Icons.edit_square,
                        color: AppColor.text_1,
                        size: 25.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35.h),
              // const AppTextFieldWidget(
              //   textFieldTitle: "Account Type",
              //   textFieldHintText: "ex: 250",
              //   ignorePointerActive: true,
              // ),
              SizedBox(height: 15.h),
              AppTextFieldWidget(
                textFieldTitle: "Name",
                textFieldHintText: "Name",
                controller: nameController,
              ),
              SizedBox(height: 15.h),
              AppTextFieldWidget(
                textFieldTitle: "Email",
                textFieldHintText: "Email",
                controller: emailController,
              ),
              SizedBox(height: 15.h),
              AppTextFieldWidget(
                textFieldTitle: "Phone Number",
                textFieldHintText: "ex: 088811110808",
                controller: phoneController,
              ),
              SizedBox(height: kToolbarHeight + 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chooseImageAction() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.h),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  profilePicture = await AppImagePickerServiceCS().getImageAsBase64().then(
                    (value) {
                      setState(() {});
                      if (value != null) {
                        return value;
                      } else {
                        return "";
                      }
                    },
                  );
                },
                child: Container(
                  height: 120.h,
                  width: 120.h,
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        size: 50.h,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Change Image",
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              InkWell(
                onTap: () async {
                  Get.back();
                  setState(() {
                    seeImage = true;
                  });
                },
                child: Container(
                  height: 120.h,
                  width: 120.h,
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_search_outlined,
                        size: 50.h,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "See Image",
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // child: Text("Bottom Sheet"),
        );
      },
    );
  }
}
