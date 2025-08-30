import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isLoginPage = true;

  changeScreen() {
    isLoginPage = !isLoginPage;
    emit(AuthInitial());
  }
}
