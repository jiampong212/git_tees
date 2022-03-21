import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:git_tee/tshirts_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';

final tshirtsProvider = StateNotifierProvider<TshirtsProvider, List<Tshirts>>((ref) {
  return TshirtsProvider();
});

final productProvider = StateProvider<Tshirts>((ref) {
  return Tshirts.empty();
});

final sortColumnIndexProvider = StateProvider<int?>((ref) {
  return;
});

final sortAscendingProvider = StateProvider<bool>((ref) {
  return false;
});

final mysqlSettingsProvider = StateProvider<ConnectionSettings>((ref) {
  return ConnectionSettings();
});

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static final TextEditingController _userNamecontroller = TextEditingController();
  static final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/bg3-cropped.jpeg'),
          fit: BoxFit.fitWidth,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.93),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              Text(
                'GIT \'TEES',
                style: GoogleFonts.exo2(
                  textStyle: const TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.blue,
                      autofocus: true,
                      controller: _userNamecontroller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.blue,
                      onSubmitted: (value) {
                        enter(context, ref);
                      },
                      obscureText: true,
                      controller: _passwordcontroller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          enter(context, ref);
                        },
                        child: const Text('Log in'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void enter(BuildContext context, WidgetRef ref) async {
    if (_userNamecontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      EasyLoading.showError('Username or password can not be empty');
      return;
    }

    if (_userNamecontroller.text.trim() != 'admin' || _passwordcontroller.text.trim() != 'admin') {
      EasyLoading.showError('Incorrect username or password');
      return;
    }

    await ref.read(tshirtsProvider.notifier).init(ref);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ),
    );
    _userNamecontroller.clear();
    _passwordcontroller.clear();
  }
}
