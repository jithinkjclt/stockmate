import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stockmate/core/utils/page_navigation.dart';
import 'package:stockmate/presentation/screens/auth/auth_screen.dart';
import 'package:stockmate/presentation/screens/home_page/home_screen.dart';

import '../../../../data/datasources/local/shared_pref.dart';
import '../../bottombar/bottombar.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init(context) async {
    print("funtion is calling");
    await Future.delayed(const Duration(seconds: 1));

    final userRepository = UserService();
    final hasUser = await userRepository.isLoggedIn();

    if (hasUser) {
      Screen.openAsNewPage(context, BottomBar());
    } else {
      Screen.openAsNewPage(context, AuthScreen());
    }
  }
}
