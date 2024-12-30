import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/bloc/pose/pose_bloc.dart';
import 'package:one_fit_man/bloc/pose/pose_event.dart';
import 'package:one_fit_man/bloc/pose/pose_state.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';
import 'package:one_fit_man/models/pose/pose_painter.dart';
import 'package:one_fit_man/repositories/permission/permission_repository.dart';
import 'package:one_fit_man/repositories/pose/pose_repository.dart';
import 'package:one_fit_man/screens/pose/detector_view.dart';

class PoseScreen extends StatefulWidget {
  final PoseAction? poseAction;

  const PoseScreen({super.key, required this.poseAction});

  @override
  State<PoseScreen> createState() => _PoseScreenState();
}

class _PoseScreenState extends State<PoseScreen> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSourceAsset('pose_done.wav');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poseAction?.type.name ?? ''),
      ),
      body: BlocProvider(
        create: (_) => PoseBloc(
            poseRepository: PoseRepository(),
            permissionRepository: PermissionRepository())
          ..add(PoseRequestPermissionEvent(poseAction: widget.poseAction)),
        child: BlocBuilder<PoseBloc, PoseState>(
          builder: (context, state) {
            if (state is PoseProcessedState) {
              _isBusy = false;

              if (state.didCount) {
                _audioPlayer.resume();
              }
            }
            return _poseWidgets(state, context);
          },
        ),
      ),
    );
  }

  Widget _poseWidgets(PoseState state, BuildContext context) =>
      state.cameraPermissionState == PermissionState.granted
          ? _cameraWidget(state, context)
          : const Center(child: CircularProgressIndicator());

  Widget _cameraWidget(PoseState state, BuildContext context) {
    return Column(
      children: [
        Text(
          '${state.poseAction?.done}/${state.poseAction?.total}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 550,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: DetectorView(
            title: 'Pose Detector',
            customPaint: _customPaint,
            text: _text,
            onImage: (inputImage) => _processImage(inputImage, context),
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) =>
                _cameraLensDirection = value,
          ),
        ),
      ],
    );
  }

  Future<void> _processImage(
      InputImage inputImage, BuildContext blocContext) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      _customPaint = null;
    }

    if (blocContext.mounted) {
      blocContext.read<PoseBloc>().add(PoseProcessPosesEvent(poses: poses));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }
}
