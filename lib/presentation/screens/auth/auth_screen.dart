import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/core/utils/page_navigation.dart';
import 'package:stockmate/presentation/screens/bottombar/bottombar.dart';
import 'package:stockmate/presentation/screens/home_page/home_screen.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/custom_apptext.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/snackbar.dart';
import 'cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            final cubit = context.read<AuthCubit>();
            if (state is AuthSuccess) {
              ShowCustomSnackbar.success(
                context,
                message: cubit.isLoginPage
                    ? "Login Successful!"
                    : "Account Created!",
              );
              if (cubit.isLoginPage == false) {
                cubit.changeScreen();
              } else {
                Screen.openAsNewPage(context, BottomBar());
              }
            } else if (state is AuthError) {
              ShowCustomSnackbar.error(context, message: state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            AppText(
                              cubit.isLoginPage
                                  ? 'Login to Stockmate '
                                  : 'Create a Stockmate Account',
                              color: blackText,
                              size: 18,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                        30.hBox,
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: cubit.isLoginPage
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    CustomTextField(
                                      controller: cubit.userNameController,
                                      width: double.infinity,
                                      boxname: 'User Name',
                                      hintText: 'Enter User Name',
                                    ),
                                    10.hBox,
                                  ],
                                ),
                        ),
                        CustomTextField(
                          controller: cubit.emailController,
                          width: double.infinity,
                          boxname: 'Email',
                          hintText: 'Enter email',
                        ),
                        10.hBox,
                        CustomTextField(
                          controller: cubit.passwordController,
                          width: double.infinity,
                          boxname: 'Password',
                          hintText: 'Enter password',
                          isPassword: true,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: cubit.isLoginPage
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    10.hBox,
                                    CustomTextField(
                                      controller:
                                          cubit.confirmPasswordController,
                                      width: double.infinity,
                                      boxname: 'Confirm Password',
                                      hintText: 'Enter password again',
                                      isPassword: true,
                                    ),
                                  ],
                                ),
                        ),
                        40.hBox,
                        CustomButton(
                          width: double.infinity,
                          boxColor: primaryColor,
                          onTap: () {
                            if (cubit.isLoginPage == true) {
                              cubit.login();
                            } else {
                              cubit.signUp();
                            }
                          },
                          isLoading: state is AuthLoading,
                          text: cubit.isLoginPage ? 'Login' : 'Sign Up',
                        ),
                        30.hBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              cubit.isLoginPage
                                  ? 'Don’t have an account?'
                                  : 'Already have an account?',
                              color: lightBlackColor,
                              size: 14,
                              weight: FontWeight.w400,
                            ),
                            5.wBox,
                            InkWell(
                              onTap: () {
                                cubit.changeScreen();
                              },
                              child: AppText(
                                cubit.isLoginPage
                                    ? 'Create an account'
                                    : 'Log in',
                                color: const Color(0xFF36ACBA),
                                size: 14,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        25.hBox,
                        Divider(color: greyBorder),
                        25.hBox,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
