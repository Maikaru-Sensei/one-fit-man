import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/home/home_bloc.dart';
import 'package:one_fit_man/bloc/home/home_event.dart';
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
  late BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocProvider(
        create: (_) => HomeBloc(
            homeRepository: HomeRepository(),
            storageRepository: StorageRepository())
          ..add(HomeFetchEvent()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.squat == null || state.pushUp == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            blocContext = context;
            return RefreshIndicator(
                displacement: 100,
                onRefresh: () async {
                  context.read<HomeBloc>().add(HomeFetchEvent());
                },
                child: SingleChildScrollView(
                    // Make the content scrollable
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (state is HomeLoadingState)
                          const LinearProgressIndicator(),
                        PoseWidget(
                          poseAction: state.squat,
                          onStart: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PoseScreen(poseAction: state.squat);
                            }));
                            if (mounted) {
                              blocContext
                                  .read<HomeBloc>()
                                  .add(HomeFetchEvent());
                            }
                          },
                        ),
                        PoseWidget(
                          poseAction: state.pushUp,
                          onStart: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PoseScreen(poseAction: state.pushUp);
                            }));
                            if (mounted) {
                              blocContext
                                  .read<HomeBloc>()
                                  .add(HomeFetchEvent());
                            }
                          },
                        ),
                        PoseWidget(
                          poseAction: state.sitUp,
                          onStart: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PoseScreen(poseAction: state.sitUp);
                            }));
                            if (mounted) {
                              blocContext
                                  .read<HomeBloc>()
                                  .add(HomeFetchEvent());
                            }
                          },
                        ),
                        PoseWidget(
                          poseAction: state.running,
                          onStart: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RunningScreen(poseAction: state.running);
                            }));
                            if (mounted) {
                              blocContext
                                  .read<HomeBloc>()
                                  .add(HomeFetchEvent());
                            }
                          },
                        ),
                      ],
                    )));
          },
        ),
      ),
    );
  }
}
