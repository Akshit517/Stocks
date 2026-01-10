import 'package:flutter/material.dart';

class CustomSegmentedButton extends StatelessWidget {
  final void Function(Set<String>)? onSelectionChanged;
  final Set<String> selected;
  final Map<String, String> rangeIntervals;

  const CustomSegmentedButton({
    super.key,
    this.onSelectionChanged,
    required this.selected,
    required this.rangeIntervals,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: rangeIntervals.keys.map((label) {
          return ButtonSegment<String>(value: label, label: Text(label));
        }).toList(),
        selected: selected,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}
