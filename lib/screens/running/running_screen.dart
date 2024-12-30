import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/running/running_bloc.dart';
import 'package:one_fit_man/bloc/running/running_event.dart';
import 'package:one_fit_man/bloc/running/running_state.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/repositories/permission/permission_repository.dart';
import 'package:one_fit_man/repositories/running/running_repository.dart';
import 'package:one_fit_man/repositories/storage/storage_repository.dart';

class RunningScreen extends StatefulWidget {
  final PoseAction? poseAction;

  const RunningScreen({super.key, required this.poseAction});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  final RunningRepository _runningRepository = RunningRepository();
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poseAction?.type.name ?? ''),
      ),
      body: BlocProvider(
        create: (_) => RunningBloc(
            runningRepository: _runningRepository,
            permissionRepository: PermissionRepository(),
            storageRepository: StorageRepository())
          ..add(RunningPermissionEvent()),
        child: BlocBuilder<RunningBloc, RunningState>(
          builder: (context, state) {
            if (state.isFinished) {
              _confettiController.play();
            }

            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (state.isRunning) {
                      context.read<RunningBloc>().add(RunningStopEvent());
                    } else {
                      context.read<RunningBloc>().add(RunningStartEvent());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                  ),
                  child: Icon(state.isRunning ? Icons.stop : Icons.play_arrow,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                    'Distance: ${state.poseAction.done}m / ${state.poseAction.total}m'),
                Text('Speed: ${state.speed.toStringAsFixed(2)} km/h'),
              ],
            ));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _runningRepository.positionSubscription?.cancel();
    super.dispose();
  }
}
