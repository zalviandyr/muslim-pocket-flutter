import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserBloc _userBloc;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscured = true;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _loginAction() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      _userBloc.add(UserLogin(email: email, password: password));
    }
  }

  void _obscureAction() {
    setState(() => _obscured = !_obscured);
  }

  void _toRegisterAction() {
    Get.to(() => RegisterScreen());
  }

  void _loginListener(BuildContext context, UserState state) {
    if (state is UserLoginSuccess) {
      Get.offAll(() => NavigationBarScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: _loginListener,
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: Measure.authHorizontalPadding,
                vertical: Measure.authVerticalPadding),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Image.asset(
                    Asset.mainIcon,
                    fit: BoxFit.fill,
                    height: 250.0,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Text(
                Word.login,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 2.0),
              Text(Word.fillOutTheForm),
              const SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      validator: Validation.emailValidator,
                      decoration: InputDecoration(
                        hintText: HintWord.email,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Pallette.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11.0),
                    TextFormField(
                      controller: _passwordController,
                      validator: Validation.passwordValidator,
                      obscureText: _obscured,
                      decoration: InputDecoration(
                        hintText: HintWord.password,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Pallette.black,
                        ),
                        suffixIcon: MaterialButton(
                          onPressed: _obscureAction,
                          minWidth: 0.0,
                          child: Icon(
                            _obscured ? Icons.visibility : Icons.visibility_off,
                            color: Pallette.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return PrimaryButton.loading();
                        }

                        return PrimaryButton(
                          label: Word.login,
                          onPressed: _loginAction,
                        );
                      },
                    ),
                    const SizedBox(height: 30.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: Word.dontHaveAnAccount,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: Word.register.toLowerCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _toRegisterAction,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
