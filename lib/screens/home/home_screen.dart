import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/home/home_bloc.dart';
import 'package:one_fit_man/bloc/home/home_state.dart';
import 'package:one_fit_man/repositories/home/home_repository.dart';
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
        create: (_) => HomeBloc(homeRepository: HomeRepository()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.squat == null || state.pushUp == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                PoseWidget(poseAction: state.squat, onStart: () {}),
                PoseWidget(
                  poseAction: state.pushUp,
                  onStart: () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
