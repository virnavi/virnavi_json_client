import 'package:example/data/api/photo/photo_list_api.dart';
import 'package:example/data/network/photo_network_impl.dart';
import 'package:example/ui/home/cubits/note/photo_cubit.dart';
import 'package:example/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhotoCubit(PhotoNetworkImpl(PhotoListApi())),
        ),
      ],
      child: MaterialApp(
        title: '',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
