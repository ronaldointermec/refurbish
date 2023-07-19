import 'package:refurbish_web/model/User.dart';
import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:rxdart/rxdart.dart';

class UserManager extends Manager {
  final PublishSubject<User> _userPreferences = PublishSubject<User>();

  Sink<User> get inUserPreferences => _userPreferences.sink;

  Stream<User> get userPreferences$ =>
      Stream.fromFuture(UserService.getUserPreferentes());

  UserManager() {
    _userPreferences.listen(UserService.setUserPreferences);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
