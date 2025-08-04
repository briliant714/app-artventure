import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password;

  // Konstruktor default untuk menciptakan model kosong
  UserModel();

  // Konstruktor untuk menciptakan model dengan nilai
  UserModel.create({
    required this.email,
    required this.password,
  });
}