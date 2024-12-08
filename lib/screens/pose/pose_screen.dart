import 'package:flutter/material.dart';
import 'package:one_fit_man/models/home/pose_action.dart';

class PoseScreen extends StatefulWidget {
  final PoseAction? poseAction;

  const PoseScreen({super.key, required this.poseAction});

  @override
  State<PoseScreen> createState() => _PoseScreenState();
}

class _PoseScreenState extends State<PoseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose'),
      ),
      body: const Center(
        child: Text('Pose Screen'),
      ),
    );
  }
}
