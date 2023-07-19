import 'package:flutter/material.dart';
import 'package:refurbish_web/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:refurbish_web/theme/theme.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'SsoService.dart';

class UserService {
  static Future<User> logar(User user, context) async {
    if (await SsoServices.getAuthentication(336) == 200) {
      try {
        final _url = Uri.parse('${Global.URL_SIP}/User/Validate');
        var corpo = json.encode(user.toJason());

        // var body = jsonEncode(
        //     {
        //       "User":"E841371",
        //       "Md5Pass":"81dc9bdb52d04dc20036dbd8313ed055"
        //     }
        // );

        http.Response response = await http.post(
            _url,
            // headers:{'Content-Type': 'application/json; charset=utf-8'},
            headers: Global.HEADERS,
            body: corpo
        );

        User usuario = User.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return usuario;
        } else if (response.statusCode == 400) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppTheme.scaffoldBackgroundColor,
                  title: Text(
                    'Usuário/Senha incorretos!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
                //throw new Exception(response.body);
              });
        } else {
          //throw new Exception("Falha ao conectar-se ao servidor!");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppTheme.scaffoldBackgroundColor,
                  title: Text(
                    'Falha ao conectarse ao servidor!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
                //throw new Exception(response.body);
              });
        }
      } on Exception catch (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Falha ao conectarse ao servidor ${error}!'),
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppTheme.scaffoldBackgroundColor,
              title: Text(
                'SSO: Falha ao ao autenticar!',
                style: TextStyle(color: Colors.white),
              ),
            );
            //throw new Exception(response.body);
          });
    }
  }

  static setUserPreferences(User user) async {
    try {
      var sharedInstance = await SharedPreferences.getInstance();
      List<String> userList = [user.Name, user.Username];
      await sharedInstance.setStringList('user', userList);
      print('salvo com sucesso');
    } catch (err) {
      print("Erro ao salvar preferencias: $err");
    }
  }

  static Future<User> getUserPreferentes() async {
    User user;
    try {
      var sharedInstance = await SharedPreferences.getInstance();
      List<String> list = await sharedInstance.getStringList('user');

      if (list != null && list.length > 0) {
        for (int index = 0; index < list.length; index++) {
          user = User.userPreferences(list[0], list[1]);
        }
      } else {
        user = User.userPreferences('User name', 'EID');
      }
      return user;
    } catch (err) {
      throw err;
    }
  }

  static Future<String> getUserEidPreferentes() async {
    try {
      User user;
      var sharedInstance = await SharedPreferences.getInstance();
      List<String> list = await sharedInstance.getStringList('user');
      for (int index = 0; index < list.length; index++) {
        user = User.userPreferences(list[0], list[1]);
      }

      return user.Username;
    } catch (err) {
      return null;
    }
  }

  static deleteUserPreferences() async {
    try {
      var sharedInstance = await SharedPreferences.getInstance();
      sharedInstance.remove('user');
    } catch (err) {
      throw err;
    }
  }
}
