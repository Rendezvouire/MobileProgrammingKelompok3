import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback? onRetake;

  const ImagePreviewWidget({
    Key? key,
    this.imageFile,
    this.imageUrl,
    this.onRetake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null && imageUrl == null) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Belum ada foto yang diambil',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
        if (onRetake != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: onRetake,
                tooltip: 'Foto Ulang',
              ),
            ),
          ),
      ],
    );
  }
}
