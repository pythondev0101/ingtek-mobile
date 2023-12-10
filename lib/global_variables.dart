import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ingtek_mobile/models/user_model.dart';

ValueNotifier<String> globalAppBarTitle = ValueNotifier<String>('Ingtek');
ValueNotifier<User> globalCurrentUser = ValueNotifier<User>(User.fromJson({}));
Db? globalMongoDB;
