import 'dart:async';

import 'package:flutterlistbloc/models/user.dart';
import 'package:flutterlistbloc/service/user_service.dart';

class UserBloc {
  Stream<List<User>> get userList async* {
    yield await UserService.browse();
  }

// MIDE EL TAMAÑO DE LA LISTA //
  final StreamController<int> _userCounter = StreamController<int>();
  Stream<int> get userCounter => _userCounter.stream;

  UserBloc() {
    userList.listen((list) => _userCounter.add(list.length));
  }
}
