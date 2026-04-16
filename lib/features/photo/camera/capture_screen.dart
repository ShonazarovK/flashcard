import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../painters/cmaera_overlay.dart';
import '../crop/crop_screen.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  bool _busy = false;
  String? _err;
  bool _flashOn = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (!mounted) return;
        setState(() => _err = "No camera found");
        return;
      }

      final back = cams.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      final c = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await c.initialize();
      await c.setFlashMode(FlashMode.off);

      if (!mounted) return;
      setState(() => _controller = c);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = "Camera init failed: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    try {
      setState(() => _flashOn = !_flashOn);
      await c.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = "Flash failed: $e");
    }
  }

  Future<void> _openCrop(File imageFile) async {
    final File? cropped = await Navigator.of(context).push<File?>(
      MaterialPageRoute(
        builder: (_) => CropScreen(imageFile: imageFile),
      ),
    );

    if (!mounted) return;

    // Crop bekor qilinsa
    if (cropped == null) return;

    // ✅ CaptureScreen natija sifatida CROPPED file qaytaradi
    Navigator.pop(context, cropped);
  }

  Future<void> _shoot() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized || _busy) return;

    setState(() {
      _busy = true;
      _err = null;
    });

    try {
      final XFile x = await c.takePicture();
      if (!mounted) return;

      // ✅ olingan rasmni cropga olib o‘tamiz
      await _openCrop(File(x.path));
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = "Capture failed: $e");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFromGalleryAndCrop() async {
    if (_busy) return;

    setState(() {
      _busy = true;
      _err = null;
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );
      if (!mounted) return;

      if (picked == null) return;

      // ✅ tanlangan rasmni cropga olib o‘tamiz
      await _openCrop(File(picked.path));
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = "Gallery pick failed: $e");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (c != null && c.value.isInitialized)
              Positioned.fill(child: CameraPreview(c))
            else
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),

            // overlay
            const Positioned.fill(
              child: IgnorePointer(child: ScanOverlay()),
            ),

            // close
            Positioned(
              left: 12,
              top: 12,
              child: _TopIcon(
                icon: Icons.close,
                onTap: () => Navigator.of(context).pop(null),
              ),
            ),
            // flash + gallery
            Positioned(
              right: 12,
              top: 12,
              child: Row(
                children: [
                  _TopIcon(
                    icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: _busy ? null : _toggleFlash,
                  ),
                  const SizedBox(width: 8),
                  _TopIcon(
                    icon: Icons.photo_library_outlined,
                    onTap: _busy ? null : _pickFromGalleryAndCrop,
                  ),
                ],
              ),
            ),

            // shutter
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: GestureDetector(
                  onTap: _busy ? null : _shoot,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      color: Colors.white.withOpacity(_busy ? 0.3 : 0.1),
                    ),
                    child: _busy
                        ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                        : null,
                  ),
                ),
              ),
            ),

            if (_err != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 120,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _err!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.25),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}