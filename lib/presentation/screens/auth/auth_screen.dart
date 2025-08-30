import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/utils/margin_text.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/custom_apptext.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
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
                                  ? 'Login to Stockmate Account'
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
                                      width: double.infinity,
                                      boxname: 'User Name',
                                      hintText: 'Enter User Name',
                                    ),
                                    10.hBox,
                                  ],
                                ),
                        ),

                        CustomTextField(
                          width: double.infinity,
                          boxname: 'Email',
                          hintText: 'Enter email',
                        ),
                        10.hBox,
                        CustomTextField(
                          width: double.infinity,
                          boxname: 'Password',
                          hintText: 'Enter password',
                          isPassword: true,
                        ),

                        // Confirm password (only in signup)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: cubit.isLoginPage
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    10.hBox,
                                    CustomTextField(
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
                          borderRadius: 8,
                          textColor: colorWhite,
                          boxColor: primaryColor,
                          onTap: () {},
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
