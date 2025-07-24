import '../../data/models/user_model.dart';
import '../../data/repositories/users_repository.dart';

class UserService {
  final UsersRepository _repository = UsersRepository();

  Future<List<UserModel>> getUsers() async {
    return await _repository.listUsers();
  }
}
