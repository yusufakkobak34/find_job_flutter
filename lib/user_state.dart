import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/jobs/jobs_screen.dart';

import 'auth/login.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder:(ctx, userSnapshot){
          if(userSnapshot.data == null){
            print('Kullanıcı henüz giriş yapmamış');
            return Login();
          }
          else if(userSnapshot.hasData){
            print('Kullanıcı giriş yapmış durumda');
            return JobScreen();
          }

          else if(userSnapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text('Bir hata oluştu,sonra tekrar deneyin'),
              ),
            );
          }
          else if(userSnapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text('Bir şeyler yanlış gitti'),
            ),
          );

        }
    );
  }
}
