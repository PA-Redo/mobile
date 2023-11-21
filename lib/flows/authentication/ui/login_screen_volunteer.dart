import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/flows/account/ui/account_screen.dart';
import 'package:pa_mobile/flows/account/ui/account_screen_volunteer.dart';
import 'package:pa_mobile/flows/authentication/logic/authentication.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';
import 'package:pa_mobile/shared/widget/xbutton.dart';

class LoginScreenVolunteer extends StatefulWidget {
  LoginScreenVolunteer({super.key});

  static const routeName = '/login_volunteer';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreenVolunteer> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenVolunteer> {
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  ValueNotifier<bool> keepMeSignedCheckBox = ValueNotifier(false);
  bool _seePassword = false;

  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.green,
            background: Colors.red,
            secondary: Colors.green,
            tertiary: Colors.green,
          ),
        ),
        child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Form(
                  key: _loginKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.account_circle),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: widget.usernameController,
                            validator: FieldValidators.emailValidator,
                            focusNode: _focusNodes[0],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              icon: const Icon(Icons.lock),
                              border: const OutlineInputBorder(),
                              fillColor: const Color(0xfff3f3f4),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _seePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _seePassword = !_seePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_seePassword,
                            textInputAction: TextInputAction.done,
                            controller: widget.passwordController,
                            validator: FieldValidators.passwordValidator,
                            focusNode: _focusNodes[1],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            XButton(
                              onPressed: onLoginPressed,
                              child: const Text('Se connecter'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

      ),
    );
  }

  void onCheckBoxChange(bool? value) {
    if (value != null) {
      keepMeSignedCheckBox
        ..value = value
        ..notifyListeners();
    }
  }

  Future<void> onLoginPressed() async {
    if (_loginKey.currentState!.validate()) {
      try {
        final s = await Authentication.loginVolunteer(
          LoginRequestDto(
            username: widget.usernameController.text,
            password: widget.passwordController.text,
            firebaseToken: await SecureStorage.get('firebaseToken') ?? '',
          ),
        );
        if (s == 'success') {
          await StayLoginSecureStorage().stayLogin();
          await StayLoginSecureStorage().isVolunteer();
          await Navigator.of(context).pushNamedAndRemoveUntil(
              AccountScreenVolunteer.routeName, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
