import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/custoum_text_form_field.dart';
import 'package:todo_app/auth/register/register_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'Login';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Login ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  CustoumTextFormField(
                    keyType: TextInputType.emailAddress,
                    label: 'Email',
                    controller: emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Email ';
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                  CustoumTextFormField(
                    obscureText: true,
                    keyType: TextInputType.phone,
                    label: 'Password',
                    controller: passwordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Password ';
                      }
                      if (text.length < 6) {
                        return 'Password Should be at least 6 char';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          login(context);
                        },
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.whiteColor),
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text('Or Create Account'))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void login(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, massage: 'Waiting...');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        DialogUtils.hideLoading(context);
        DialogUtils.showMassage(
            context: context,
            content: 'Login Successfully',
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            });
        print('login successfully');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMassage(
              context: context,
              content:
                  'The supplied auth credential is incorrect, malformed or has expired.',
              title: 'Error',
              posActionName: 'Ok');
          print(
              'The supplied auth credential is incorrect, malformed or has expired.');
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMassage(
              context: context,
              content: 'Wrong password provided for that user.',
              title: 'Error',
              posActionName: 'Ok');
          print('Wrong password provided for that user.');
        } else if (e.code == 'network-request-failed') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMassage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error',
              posActionName: 'Ok');
          print(
              'A network error (such as timeout, interrupted connection or unreachable host) has occurred.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMassage(
            context: context,
            content: e.toString(),
            title: 'Error',
            posActionName: 'Ok');
        print(
          e.toString(),
        );
      }
    }
  }
}
