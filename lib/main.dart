import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:git_tee/screens/login_screen.dart';

void main() {
  Paint.enableDithering = true;

  runApp(
    const ProviderScope(
      child: GitTees(),
    ),
  );
}

final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});


class GitTees extends ConsumerWidget {
  const GitTees({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData.light(),
      themeMode: ref.watch(themeProvider),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
