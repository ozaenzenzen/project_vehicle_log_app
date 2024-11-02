import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';

class AboutThisAppPage extends StatefulWidget {
  const AboutThisAppPage({Key? key}) : super(key: key);

  @override
  State<AboutThisAppPage> createState() => _AboutThisAppPageState();
}

class _AboutThisAppPageState extends State<AboutThisAppPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: 'About This App',
      ),
    );
  }
}
