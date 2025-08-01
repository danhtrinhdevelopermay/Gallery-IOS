import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IOSNavigationBar extends StatelessWidget {
  final String title;
  final bool isSelecting;
  final int selectedCount;
  final VoidCallback? onSelectPressed;
  final VoidCallback? onDeletePressed;

  const IOSNavigationBar({
    super.key,
    required this.title,
    this.isSelecting = false,
    this.selectedCount = 0,
    this.onSelectPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5EA),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isSelecting) ...[
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontSize: 17,
                  ),
                ),
                onPressed: onSelectPressed,
              ),
              Text(
                selectedCount > 0 ? '$selectedCount mục đã chọn' : 'Chọn mục',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.delete,
                  color: selectedCount > 0 
                      ? CupertinoColors.destructiveRed 
                      : CupertinoColors.inactiveGray,
                  size: 24,
                ),
                onPressed: onDeletePressed,
              ),
            ] else ...[
              const SizedBox(width: 60), // Spacer for alignment
              Text(
                title,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text(
                  'Chọn',
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontSize: 17,
                  ),
                ),
                onPressed: onSelectPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}