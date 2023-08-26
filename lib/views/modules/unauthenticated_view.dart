import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overtimed/controllers/firebase_authentication/firebase_authentication_controller.dart';
import 'package:overtimed/helpers/authentication_helper.dart';

import '/controllers/user_authentication.dart';

class UnauthenticatedView extends StatelessWidget {
  UnauthenticatedView({super.key});
  RxBool showAdmin = true.obs;
  @override
  Widget build(BuildContext context) {
    handleAuthentiation() {
      authenticateUser();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Project overtime record'),
      ),
      body: Center(
        child: Obx(() => showAdmin.value
            ? AdminLoginpage()
            : ElevatedButton(
                onPressed: () => handleAuthentiation(),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Sign in with GOOGLE'),
                ),
              )),
      ),
      floatingActionButton: TextButton(
          onPressed: () => showAdmin.value = !showAdmin.value,
          child: Text('admin')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class AdminLoginpage extends StatelessWidget {
  AdminLoginpage({super.key});
  RxBool loadingLogin = false.obs;

  _onSubmitLogin() async {
    try {
      loadingLogin.value = true;
      await adminLogin();

      is_authenticated.value = true;
      // selectedIndex.state.value = 0;
    } catch (e) {
      print(e);
    }
    loadingLogin.value = false;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var paddingTop = screenHeight / 4;

    if (screenHeight < 400) {
      paddingTop = 20;
    }

    return Container(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: paddingTop),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: min(400, MediaQuery.of(context).size.width),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          label: Text('email'),
                        ),
                        controller: adminEmail.value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('password'),
                        ),
                        controller: adminPassword.value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _onSubmitLogin,
                        child: Obx(
                          () => loadingLogin.value
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )
                              : Text('Submit'),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(51)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
