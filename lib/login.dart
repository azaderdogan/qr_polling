import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'main.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String pass = passController.text;
                  if (email.isNotEmpty && pass.isNotEmpty) {
                    Dio dio = Dio();
                    var result = await dio.post(
                        'http://oguzhantursun.com/qr_yoklama/public/api/login',
                        data: {
                          'email': email,
                          'password': pass,
                        });
                    print(result.data);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          QRViewExample(token: result.data['token']),
                    ));
                  }
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
