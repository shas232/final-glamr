import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_glamr/services/search_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_glamr/screens/ResultsScreen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  XFile? _imageFile;
  Uint8List? _imageBytes;
  List<CameraDescription>? cameras;
  int _selectedCameraIndex = 0;

  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }
  Future<void> _processAndNavigate() async {
    if (_imageBytes == null) return;
    if (_isProcessing) return;

    // Debounce the function calls
    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {});
    setState(() {
      _isProcessing = true;
    });

    try {
      final uploadResponse = await _apiService.getUploadUrl();

      final String uploadUrl = uploadResponse['upload_url'];
      final String s3Key = uploadResponse['key'];

      await _apiService.uploadImageToS3(uploadUrl, _imageBytes!);

      final searchResults = await _apiService.searchOptions(s3Key);

      if (mounted) Navigator.of(context).pop();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            capturedImage: _imageBytes!,
            searchResults: searchResults,
          ),
        ),
      );
    } catch (e) {

      if (mounted) Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
    _debounceTimer?.cancel();
    await _cameraController?.dispose();

    _cameraController = CameraController(
      cameras![_selectedCameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!kIsWeb) {
        await _cameraController!.setZoomLevel(_currentScale);
      }
      setState(() {});
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isEmpty) return;
    _debounceTimer?.cancel();
    await _cameraController?.dispose();
    _cameraController = CameraController(
      cameras![_selectedCameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    if (!kIsWeb) {
      await _cameraController!.setZoomLevel(_currentScale);
    }
    setState(() {});
  }

  Future<void> captureImage() async {
    if (_cameraController != null) {
      try {
        if (!kIsWeb) {
          await _cameraController!.setZoomLevel(_currentScale);
        }

        final image = await _cameraController!.takePicture();
        final imageBytes = await image.readAsBytes();

        setState(() {
          _imageFile = image;
          _imageBytes = imageBytes;
        });
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }


  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = XFile(pickedFile.path);
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final Size screenSize = MediaQuery.of(context).size;
      final bool isPhone = screenSize.width < 600;
      final double captureButtonSize = isPhone ? 70 : 90;
      final double sideButtonSize = isPhone ? 50 : 65;
      final double iconSize = isPhone ? 30 : 40;
      final double buttonPadding = isPhone ? 20 : 40;
      final double bottomBarPadding = screenSize.height * 0.03;
      final double actionButtonWidth = isPhone ? 100 : 150;
      final double actionButtonHeight = isPhone ? 45 : 60;
      final double actionButtonFontSize = isPhone ? 16 : 20;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Accounts for status bar
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: isPhone ? 24 : 30,
                ),
              ),
            ),
          ),
          // Fullscreen camera preview or selected image
          Positioned.fill(
            child: _imageFile == null
                ? (_cameraController != null && _cameraController!.value.isInitialized
                ? GestureDetector(
              onScaleUpdate: (details) {
                const double zoomSensitivity = 0.02;
                final newScale = (_currentScale + (details.scale - 1) * zoomSensitivity).clamp(1.0, 5.0);
                setState(() {
                  _currentScale = newScale;
                });
                _cameraController!.setZoomLevel(_currentScale);
              },
              child: CameraPreview(_cameraController!),
            )
                : const Center(child: CircularProgressIndicator()))
                : Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: bottomBarPadding),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(isPhone ? 20 : 30)
                        ),
                      ),
                      child: _imageFile == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: sideButtonSize,
                                  margin: EdgeInsets.only(left: buttonPadding),
                                  child: GestureDetector(
                                    onTap: pickImageFromGallery,
                                    child: Container(
                                      width: sideButtonSize,
                                      height: sideButtonSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(isPhone ? 8 : 12),
                                        border: Border.all(color: Colors.white, width: isPhone ? 2 : 3),
                                      ),
                                      child: Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                        size: iconSize,
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: captureImage,
                                  child: Container(
                                    width: captureButtonSize,
                                    height: captureButtonSize,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: isPhone ? 4 : 6
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: sideButtonSize,
                                  margin: EdgeInsets.only(right: buttonPadding),
                                  child: !kIsWeb && cameras != null && cameras!.length > 1
                                      ? GestureDetector(
                                          onTap: switchCamera,
                                          child: Container(
                                            width: sideButtonSize,
                                            height: sideButtonSize,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(isPhone ? 8 : 12),
                                              border: Border.all(color: Colors.white, width: isPhone ? 2 : 3),
                                            ),
                                            child: Icon(
                                              Icons.flip_camera_ios,
                                              color: Colors.white,
                                              size: iconSize,
                                            ),
                                          ),
                                        )
                                      : SizedBox(width: sideButtonSize),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: screenSize.width * (isPhone ? 0.15 : 0.25)),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _imageFile = null;
                                        _imageBytes = null;
                                        _currentScale = 1.0;
                                      });
                                      await initializeCamera();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isPhone ? 30 : 40,
                                        vertical: isPhone ? 12 : 16
                                      ),
                                      minimumSize: Size(actionButtonWidth, actionButtonHeight),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(isPhone ? 8 : 12),
                                      ),
                                    ),
                                    child: Text(
                                      "Retake",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: actionButtonFontSize
                                      )
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(right: screenSize.width * (isPhone ? 0.15 : 0.25)),
                                  child: ElevatedButton(
                                    onPressed: _isProcessing ? null : _processAndNavigate,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isPhone ? 30 : 40,
                                        vertical: isPhone ? 12 : 16
                                      ),
                                      minimumSize: Size(actionButtonWidth, actionButtonHeight),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(isPhone ? 8 : 12),
                                      ),
                                    ),
                                    child: _isProcessing
                                        ? SizedBox(
                                            width: isPhone ? 20 : 25,
                                            height: isPhone ? 20 : 25,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: isPhone ? 2 : 3
                                            ),
                                          )
                                        : Text(
                                            "Search",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: actionButtonFontSize
                                            )
                                          ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          }
}
