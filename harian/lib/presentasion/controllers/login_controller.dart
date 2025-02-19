import 'package:get/get.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/datasources/user_remote_data_source.dart';

class LoginController extends GetxController {
  final _state = LoginState(
    message: '',
    statusRequest: StatusRequest.init,
  ).obs;
  LoginState get state => _state.value;
  set state(LoginState n) => _state.value = n;

  Future<LoginState> executeRequest(
    String email,
    String password,
  ) async {
    state = state.copyWith(
      statusRequest: StatusRequest.loading,
    );

    final (
      success,
      message,
      user,
    ) = await UserRemoteDataSource.login(email, password);

    if (success) {
      Session.saveUser(user!.toJson());
    }

    state = state.copyWith(
      statusRequest: success ? StatusRequest.success : StatusRequest.failed,
      message: message,
    );

    return state;
  }

  static delete() => Get.delete<LoginController>(force: true);
}

class LoginState {
  final StatusRequest statusRequest;
  final String message;

  LoginState({
    required this.statusRequest,
    required this.message,
  });

  LoginState copyWith({
    StatusRequest? statusRequest,
    String? message,
  }) {
    return LoginState(
      statusRequest: statusRequest ?? this.statusRequest,
      message: message ?? this.message,
    );
  }
}
