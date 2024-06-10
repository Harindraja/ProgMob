import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/components/square_tile.dart';
import 'package:modernlogintute/pages/register_page.dart';
import 'member_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
    required this.dio,
    required this.storage,
    required this.apiUrl,
  }) : super(key: key);

  final Dio dio;
  final GetStorage storage;
  final String apiUrl;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void goLogin(BuildContext context) async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();

    try {
      final response = await dio.post(
        '$apiUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Simpan token ke GetStorage
      if (response.statusCode == 200 && response.data['data']['token'] != null) {
        storage.write('token', response.data['data']['token']);
        
        // Navigasi ke halaman member
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MemberPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
      print(response.data);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.response?.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: 800,
            bottom: 0,
            left: 43,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8),
                BlendMode.dstATop,
              ),
              child: Image(
                image: AssetImage('lib/images/bawah.png'),
              ),
            ),
          ),
          Positioned(
            height: 140,
            top: 0,
            left: 0,
            right: 0,
            child: Image(
              image: AssetImage('lib/images/atas.png'),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    SizedBox(
                      height: 180,
                      child: Image(
                        image: AssetImage('lib/images/logo.png'),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'IT-ESEGA 2024',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 25),
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        goLogin(context);
                      },
                      child: const Text('Login'),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(imagePath: 'lib/images/google.png'),
                        SizedBox(width: 25),
                        SquareTile(imagePath: 'lib/images/facebook.png'),
                        SizedBox(width: 25),
                        SquareTile(imagePath: 'lib/images/twitter.png')
                      ],
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_createRoute());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Register now',
                            style: TextStyle(
                              color: Color.fromARGB(255, 49, 158, 198),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
