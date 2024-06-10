import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/components/square_tile.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Dio dio = Dio(); // Inisialisasi Dio

  void registerUser(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Kirim permintaan POST ke endpoint register
      final response = await dio.post('https://mobileapis.manpits.xyz/api/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      // Jika berhasil, simpan data ke SharedPreferences
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
        await prefs.setString('email', email);

        // Navigasi ke halaman berikutnya atau tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
      }
    } on DioError catch (e) {
      // Tangani jika terjadi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.response?.statusCode} - ${e.response?.data}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: emailController,
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
                    MyButton(
                      onTap: () => registerUser(context),
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
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Sign in here',
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
