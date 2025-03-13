import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late UserBloc _userBloc;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;
  String? _passwordErrorText;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _registerAction() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        setState(() => _passwordErrorText = ValidationWord.passwordNotSame);
      } else {
        setState(() => _passwordErrorText = null);

        _userBloc
            .add(UserRegister(name: name, email: email, password: password));
      }
    }
  }

  void _passwordObscureAction() {
    setState(() => _passwordObscured = !_passwordObscured);
  }

  void _confirmPasswordObscureAction() {
    setState(() => _confirmPasswordObscured = !_confirmPasswordObscured);
  }

  void _toLoginAction() {
    Get.back();
  }

  void _registerListener(BuildContext context, UserState state) {
    if (state is UserRegisterSuccess) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: _registerListener,
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
                Word.register,
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
                      controller: _nameController,
                      validator: Validation.inputRequired,
                      decoration: InputDecoration(
                        hintText: HintWord.name,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Pallette.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11.0),
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
                      obscureText: _passwordObscured,
                      decoration: InputDecoration(
                        hintText: HintWord.password,
                        errorText: _passwordErrorText,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Pallette.black,
                        ),
                        suffixIcon: MaterialButton(
                          onPressed: _passwordObscureAction,
                          minWidth: 0.0,
                          child: Icon(
                            _passwordObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Pallette.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: Validation.passwordValidator,
                      obscureText: _confirmPasswordObscured,
                      decoration: InputDecoration(
                        hintText: HintWord.confirmPassword,
                        errorText: _passwordErrorText,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Pallette.black,
                        ),
                        suffixIcon: MaterialButton(
                          onPressed: _confirmPasswordObscureAction,
                          minWidth: 0.0,
                          child: Icon(
                            _confirmPasswordObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                          label: Word.register,
                          onPressed: _registerAction,
                        );
                      },
                    ),
                    const SizedBox(height: 30.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: Word.haveAnAccount,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: Word.login.toLowerCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _toLoginAction,
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
