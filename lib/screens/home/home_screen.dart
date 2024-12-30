import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/home/home_bloc.dart';
import 'package:one_fit_man/bloc/home/home_state.dart';
import 'package:one_fit_man/repositories/home/home_repository.dart';
import 'package:one_fit_man/repositories/storage/storage_repository.dart';
import 'package:one_fit_man/screens/pose/pose_screen.dart';
import 'package:one_fit_man/screens/running/running_screen.dart';
import 'package:one_fit_man/widgets/home/pose_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocProvider(
        create: (_) => HomeBloc(
            homeRepository: HomeRepository(),
            storageRepository: StorageRepository()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.squat == null || state.pushUp == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                PoseWidget(
                  poseAction: state.squat,
                  onStart: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PoseScreen(poseAction: state.squat);
                    }));
                  },
                ),
                PoseWidget(
                  poseAction: state.pushUp,
                  onStart: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PoseScreen(poseAction: state.pushUp);
                    }));
                  },
                ),
                PoseWidget(
                  poseAction: state.sitUp,
                  onStart: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PoseScreen(poseAction: state.sitUp);
                    }));
                  },
                ),
                PoseWidget(
                  poseAction: state.running,
                  onStart: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RunningScreen(poseAction: state.running);
                    }));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
