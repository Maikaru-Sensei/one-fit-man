import 'package:flutter/material.dart';
import 'package:one_fit_man/models/home/pose_action.dart';

class PoseWidget extends StatelessWidget {
  final PoseAction? poseAction;
  final Function() onStart;

  const PoseWidget(
      {super.key, required this.poseAction, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final poseImage = poseAction?.type == PoseType.squat
        ? 'assets/pose_squat.png'
        : 'assets/pose_pushup.png';

    final progressColor = poseAction?.done == poseAction?.total
        ? Colors.green
        : poseAction?.done == 0
            ? Colors.orange
            : Colors.yellow;

    return Card(
        color: progressColor,
        elevation: 6,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(0), // Space for the black border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: CircleAvatar(
                    child: Image.asset(poseImage),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  poseAction?.type.name ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(width: 10),
                Text(
                  '${poseAction?.done}/${poseAction?.total}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      onStart();
                    },
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.black,
                      size: 40,
                    ))
              ],
            )));
  }
}
