import 'package:flutter/material.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
            Text("Nama "),
            TextField(),
          ],
        ),
      ),
    );
  }
}
