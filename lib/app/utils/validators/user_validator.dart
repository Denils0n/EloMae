import 'package:elomae/app/models/user_model.dart';
import 'package:lucid_validation/lucid_validation.dart';

class UserValidator extends LucidValidator<UserModel>{
  UserValidator(){
    
    ruleFor((user) => user.name, key: 'name')
      .notEmpty(message: 'Digite seu nome completo');

    ruleFor((user) => user.email, key: 'email')
      .notEmpty(message: 'Digite seu email')
      .validEmail();

    ruleFor((user) => user.number, key: 'number')
      .notEmpty(message: 'Digite seu número')
      .minLength(11, message: 'Informe seu número no formato (DDD) 99999-9999.');

    ruleFor((user) => user.password, key: 'password')
      .notEmpty(message: 'Digite uma senha')
      .minLength(8, message: 'A senha deve ter no minímo 8 caracteres')
      .mustHaveLowercase()
      .mustHaveUppercase()
      .mustHaveNumber()
      .mustHaveSpecialCharacter();
  }
}