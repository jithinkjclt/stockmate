import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../data/datasources/local/shared_pref.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final UserService userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String email = '';

  Future<void> loadUser() async {
    final user = await userService.getUser();
    if (user != null) {
      name = user.name;
      email = user.email;
      emit(ProfileLoaded(name: name, email: email));
    }
  }

  Future<void> logout() async {
    try {
      emit(ProfileLoading());
      await _auth.signOut();
      await userService.clearUser();
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
