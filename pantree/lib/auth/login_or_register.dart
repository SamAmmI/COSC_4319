import 'package:flutter/material.dart';
import 'package:pantree/screens/register_page.dart';
import 'package:pantree/screens/sign_in.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool loginPage = true;

  void togglePages(){
    setState(() {
      loginPage = !loginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(loginPage){
      return LoginPage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}