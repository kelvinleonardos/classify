import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class FaceScanPage extends StatefulWidget {
  const FaceScanPage({super.key});

  @override
  State<FaceScanPage> createState() => _FaceScanPageState();
}

class _FaceScanPageState extends State<FaceScanPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );

    try {
      await _cameraController?.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || _isRecording) return;
    setState(() {
      _isRecording = true;
    });

    await _cameraController?.startVideoRecording();
    await Future.delayed(const Duration(seconds: 5));
    final videoFile = await _cameraController?.stopVideoRecording();

    setState(() {
      _isRecording = false;
    });

    if (videoFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputDataPage(videoFilePath: videoFile.path),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Scan'),
      ),
      body: _isCameraInitialized
          ? Center(
        child: ClipOval(
          child: SizedBox(
            width: 250,
            height: 250,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 250,
                height: 250 * (16 / 9),
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isRecording ? null : _startRecording,
        icon: const Icon(Icons.videocam),
        label: const Text('Start Recording'),
        backgroundColor: _isRecording ? Colors.grey : Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class InputDataPage extends StatefulWidget {
  final String videoFilePath;

  const InputDataPage({super.key, required this.videoFilePath});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  List<File> _extractedFrames = [];
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.file(File(widget.videoFilePath))
      ..initialize().then((_) {
        _extractFrames();
      });
  }

  Future<void> _extractFrames() async {
    final frameInterval = 0.1; // 10 fps (1 frame every 0.1 second)
    final extractedFrames = <File>[];

    final directory = await getTemporaryDirectory();
    for (double i = 0.0; i < 5.0; i += frameInterval) {
      await _videoController?.seekTo(Duration(seconds: i.floor(), milliseconds: ((i * 1000) % 1000).toInt()));
      final frameFile = await _saveCurrentFrame(directory, i);
      if (frameFile != null) extractedFrames.add(frameFile);
      if (extractedFrames.length >= 50) break;
    }

    setState(() {
      _extractedFrames = extractedFrames;
    });
  }

  Future<File?> _saveCurrentFrame(Directory directory, double timestamp) async {
    final filePath = '${directory.path}/frame_${timestamp.toStringAsFixed(1)}.png';
    final file = File(filePath);

    // Placeholder for frame capture logic, e.g., using an external package
    // Simulate a captured frame by creating an empty file (for demonstration purposes)
    await file.create();

    return file.existsSync() ? file : null;
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Extracted Frames:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: _extractedFrames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Image.file(_extractedFrames[index], fit: BoxFit.cover);
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan fungsionalitas submit di sini
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
