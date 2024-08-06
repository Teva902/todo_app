import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/custoum_text_form_field.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/fire_base_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/providers/auth_user_provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register_screen';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: AppColors.backgroundLightColor,
            child: Image.asset(
              'assets/images/background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Create Account ',
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
                    label: 'User Name',
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter User Name ';
                      }
                      return null;
                    },
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
                  CustoumTextFormField(
                    obscureText: true,
                    keyType: TextInputType.phone,
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Confirm Password ';
                      }
                      if (text != passwordController.text) {
                        return 'Please Enter The Same Password';
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
                          register(context);
                        },
                        child: Text(
                          'Create Account',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.whiteColor),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.whiteColor),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void register(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, massage: 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            name: nameController.text,
            email: emailController.text,
            id: credential.user?.uid ?? '');
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.updateUser(myUser);
        await FireBaseUtils.addUserToFireStore(myUser);
        DialogUtils.hideLoading(context);
        DialogUtils.showMassage(
            context: context,
            content: 'Register Successfully',
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
        print('Register Successfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMassage(
              context: context,
              content: 'The password provided is too weak.',
              title: 'Error',
              posActionName: 'Ok');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMassage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error',
              posActionName: 'Ok');
          print('The account already exists for that email.');
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
        print(e);
      }
    }
  }
}
