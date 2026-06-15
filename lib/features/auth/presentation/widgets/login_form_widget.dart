import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/enums/enums_state.dart';
import 'package:propertybooking/core/utils/navigation/navigation_context_extension.dart';
import 'package:propertybooking/features/auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import 'package:propertybooking/features/auth/presentation/widgets/custom_login_text_field.dart';
import 'package:propertybooking/features/auth/presentation/widgets/custom_login_button.dart';
import 'package:propertybooking/features/auth/presentation/widgets/error_dialog.dart';
import 'package:propertybooking/features/auth/presentation/widgets/login_footer_widget.dart';

import 'package:propertybooking/features/lead/mock/lead_mock_data.dart';
import '../../../../core/utils/navigation/router_path.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final inputCode = _userCodeController.text.trim();
      final inputPassword = _passwordController.text;

      // Lead manager portal shortcut
      if (inputCode == '1' && inputPassword == '1') {
        Navigator.pushNamed(context, RouterPath.leadManagerView);
        return;
      }
      
      // Salesperson portal shortcut
      if (inputCode == '2' && inputPassword == '1') {
        final salesperson = LeadMockData.salesPeople.firstWhere(
          (s) => s.id == 'SP001',
        );
        Navigator.pushNamed(
          context,
          RouterPath.salespersonHomeView,
          arguments: salesperson,
        );
        return;
      }

      context.read<AuthCubitCubit>().validateAndLogin(
        int.parse(_userCodeController.text),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubitCubit, AuthCubitState>(
      listener: (context, state) {
        // Show error dialog when login fails
        if (state.loginState == EnumState.failure) {
          String errorMessage;

          if (state.errMessege == 'userNotFound') {
            errorMessage = l10n.userNotFound;
          } else if (state.errMessege == 'invalidPassword') {
            errorMessage = l10n.invalidPassword;
          } else {
            errorMessage = l10n.invalidCredentials;
          }

          ErrorDialog.show(
            context,
            title: l10n.loginError,
            message: errorMessage,
            buttonText: l10n.tryAgain,
          );
        }
        if (state.loginState == EnumState.success) {
          context.pushReplacementNamed(
            RouterPath.homeView,
            arguments: state.userModel,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.loginState == EnumState.loading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Code Field
              CustomLoginTextField(
                controller: _userCodeController,
                label: l10n.userCode,
                hint: l10n.userCodeHint,
                icon: Icons.person_outline,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.userCodeRequired;
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              // Password Field
              CustomLoginTextField(
                controller: _passwordController,
                label: l10n.password,
                hint: l10n.passwordHint,
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.passwordRequired;
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),

              // Login Button
              CustomLoginButton(
                text: l10n.loginButton,
                onPressed: isLoading ? null : _handleLogin,
                isLoading: isLoading,
              ),

              const LoginFooterWidget(),
            ],
          ),
        );
      },
    );
  }
}
