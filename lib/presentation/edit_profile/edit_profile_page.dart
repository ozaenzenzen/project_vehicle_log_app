import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/presentation/edit_profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_bottom_navbar_button_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_image_picker.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileBloc = ProfileBloc(AccountLocalRepository());
    profileBloc = profileBloc
      ..add(
        GetProfileRemoteAction(
          accountRepository: AppAccountReposistory(),
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    profileBloc.close();
    debugPrint('disposed');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => profileBloc,
      child: WillPopScope(
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
            bottomNavigationBar: bottomView(),
            body: Stack(
              children: [
                BlocListener<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileSuccess) {
                      profilePicture = state.userDataModel.profilePicture ?? "";
                      nameController.text = state.userDataModel.name ?? "";
                      emailController.text = state.userDataModel.email ?? "";
                      phoneController.text = state.userDataModel.phone ?? "";
                      setState(() {});
                    }
                  },
                  child: formView(),
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return loadingView();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoading) {
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
      ),
    );
  }

  Widget bottomView() {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileFailed) {
          AppDialogAction.showFailedPopup(
            context: context,
            title: "Terjadi Kesalahan",
            description: "${state.errorMessage}",
            buttonTitle: "Kembali",
          );
        } else if (state is EditProfileSuccess) {
          AppDialogAction.showSuccessPopup(
            context: context,
            title: "Berhasil",
            description: "${state.editProfileResponseModel.message}",
            buttonTitle: "Kembali",
          );
        }
      },
      builder: (context, state) {
        return AppBottomNavBarButtonWidget(
          onTap: () {
            if (state is EditProfileLoading || state is ProfileLoading) {
              AppDialogAction.showFailedPopup(
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
          title: 'Update Profile',
        );
      },
    );
  }

  Widget formView() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColor.white,
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 25.h),
            InkWell(
              onTap: () {
                showModalBottomSheet(
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
                              profilePicture = await AppImagePickerService().getImageAsBase64().then(
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
                              // profilePicture = await AppImagePickerService.getImageAsBase64().then(
                              //   (value) {
                              //     setState(() {});
                              //     if (value != null) {
                              //       return value;
                              //     } else {
                              //       return "";
                              //     }
                              //   },
                              // );
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
