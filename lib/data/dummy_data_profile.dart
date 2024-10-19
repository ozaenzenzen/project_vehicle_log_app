import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/qna_screen/qna_page.dart';

class DummyDataProfileModel {
  String? menuTitle;
  String? menuDescription;
  Function()? menuFunction;

  DummyDataProfileModel({
    required this.menuTitle,
    this.menuDescription,
    required this.menuFunction,
  });
}

class ProfileDummyDataAccount {
  static List<DummyDataProfileModel> dummyDataProfileAccount = [
    DummyDataProfileModel(
      menuTitle: "Security Preferences",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Theme",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Language",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Delete Account",
      menuFunction: () {},
    ),
  ];
}

class ProfileDummyDataAbout {
  static List<DummyDataProfileModel> dummyDataProfileAbout = [
    DummyDataProfileModel(
      menuTitle: "About This App",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Questions and Answers",
      menuFunction: () {
        Get.to(
          () => const QNAPage(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Terms & Conditions",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Privacy & Policy",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Rate 'Vehicle Management Logs'",
      menuFunction: () {},
    ),
  ];
}
