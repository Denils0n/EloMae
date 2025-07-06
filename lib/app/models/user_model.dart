import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String name;
  String email;
  String number;
  String password;

  UserModel({
    this.name = '',
    this.email = '',
    this.number = '',
    this.password = '',
  });

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  void setEmail(String email){
    this.email = email;
    notifyListeners();
  }

  void setNumber(String number){
    this.number = number;
    notifyListeners();
  }

  void setPassword(String password){
    this.password = password;
    notifyListeners();
  }
  
  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, number: $number, password: $password)';
  }
}