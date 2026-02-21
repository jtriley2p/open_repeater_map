import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String? tooltip;

  const DetailRow({super.key, required this.label, required this.value, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 140,
              child:
                  tooltip != null
                      ? Tooltip(
                        message: tooltip,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )
                      : Text(label, style: const TextStyle(color: Colors.grey)),
            ),
          ],
          Expanded(child: Text(value)),
        ],
      );
  }
}
