import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../models/gallery_item.dart';

class GalleryGrid extends StatelessWidget {
  final List<GalleryItem> items;
  final bool isSelecting;
  final Set<int> selectedItems;
  final Function(int) onItemTap;
  final Function(int)? onItemLongPress;

  const GalleryGrid({
    super.key,
    required this.items,
    this.isSelecting = false,
    required this.selectedItems,
    required this.onItemTap,
    this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildGalleryItem(context, index);
        },
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, int index) {
    final item = items[index];
    final isSelected = selectedItems.contains(index);

    return GestureDetector(
      onTap: () => onItemTap(index),
      onLongPress: () => onItemLongPress?.call(index),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: CupertinoColors.systemBlue,
                      width: 3,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImageWidget(item),
            ),
          ),
          if (isSelecting)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : Colors.white.withOpacity(0.8),
                  border: Border.all(
                    color: isSelected
                        ? CupertinoColors.systemBlue
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        CupertinoIcons.check_mark,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          if (item.type == GalleryItemType.video)
            const Positioned(
              bottom: 8,
              left: 8,
              child: Icon(
                CupertinoIcons.play_circle_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(GalleryItem item) {
    if (item.path.startsWith('assets/')) {
      return Image.asset(
        item.path,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(
              CupertinoIcons.photo,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(item.path),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(
              CupertinoIcons.photo,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}