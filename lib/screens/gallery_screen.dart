import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../widgets/ios_navigation_bar.dart';
import '../widgets/gallery_grid.dart';
import '../models/gallery_item.dart';
import 'photo_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<GalleryItem> galleryItems = [];
  final ImagePicker _picker = ImagePicker();
  bool isSelecting = false;
  Set<int> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadSampleImages();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  void _loadSampleImages() {
    // Load some sample images for demo
    setState(() {
      galleryItems = [
        GalleryItem(
          id: '1',
          path: 'assets/images/sample1.jpg',
          type: GalleryItemType.image,
          dateAdded: DateTime.now().subtract(const Duration(days: 1)),
        ),
        GalleryItem(
          id: '2',
          path: 'assets/images/sample2.jpg',
          type: GalleryItemType.image,
          dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        ),
        GalleryItem(
          id: '3',
          path: 'assets/images/sample3.jpg',
          type: GalleryItemType.image,
          dateAdded: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          galleryItems.insert(0, GalleryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            path: image.path,
            type: GalleryItemType.image,
            dateAdded: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      _showErrorDialog('Không thể chọn ảnh: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          galleryItems.insert(0, GalleryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            path: image.path,
            type: GalleryItemType.image,
            dateAdded: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      _showErrorDialog('Không thể chụp ảnh: $e');
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _toggleSelection() {
    setState(() {
      isSelecting = !isSelecting;
      if (!isSelecting) {
        selectedItems.clear();
      }
    });
  }

  void _selectItem(int index) {
    if (!isSelecting) return;
    
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  void _deleteSelectedItems() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Xóa ảnh'),
        content: Text('Bạn có chắc muốn xóa ${selectedItems.length} ảnh?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Xóa'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final itemsToRemove = selectedItems.toList()..sort((a, b) => b.compareTo(a));
                for (int index in itemsToRemove) {
                  galleryItems.removeAt(index);
                }
                selectedItems.clear();
                isSelecting = false;
              });
            },
          ),
        ],
      ),
    );
  }

  void _openPhoto(int index) {
    if (isSelecting) {
      _selectItem(index);
      return;
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PhotoDetailScreen(
          galleryItems: galleryItems,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            IOSNavigationBar(
              title: 'Thư Viện',
              isSelecting: isSelecting,
              selectedCount: selectedItems.length,
              onSelectPressed: _toggleSelection,
              onDeletePressed: selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            ),
            Expanded(
              child: galleryItems.isEmpty
                  ? _buildEmptyState()
                  : GalleryGrid(
                      items: galleryItems,
                      isSelecting: isSelecting,
                      selectedItems: selectedItems,
                      onItemTap: _openPhoto,
                      onItemLongPress: (index) {
                        if (!isSelecting) {
                          _toggleSelection();
                        }
                        _selectItem(index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: !isSelecting ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.photo,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Không có ảnh nào',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm ảnh vào thư viện của bạn',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "camera",
          onPressed: _takePicture,
          backgroundColor: CupertinoColors.systemBlue,
          child: const Icon(CupertinoIcons.camera, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "gallery",
          onPressed: _pickImage,
          backgroundColor: CupertinoColors.systemBlue,
          child: const Icon(CupertinoIcons.photo, color: Colors.white),
        ),
      ],
    );
  }
}