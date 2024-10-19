import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';

class QNAPage extends StatefulWidget {
  const QNAPage({Key? key}) : super(key: key);

  @override
  State<QNAPage> createState() => _QNAPageState();
}

class _QNAPageState extends State<QNAPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: 'Questions And Answers',
      ),
    );
  }
}
