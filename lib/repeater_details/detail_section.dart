import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DetailSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ...children,
      ],
    );
  }
}
