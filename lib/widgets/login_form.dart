import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/user_auth.dart';
import 'package:gotour_mobile/widgets/main_menu.dart';

class LoginForm extends StatefulWidget {
  final void Function(String type) toggleType;
  const LoginForm({Key? key, required this.toggleType}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void _handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final response = await postUserLogin(emailCtrl.text, passwordCtrl.text);
      if (response.meta.code == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wrong credentials'),
        ));
      } else if (response.meta.code == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validate,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordCtrl,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validate,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : _handleSubmit,
              child: isLoading
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('LOGIN'),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => widget.toggleType('register'),
                  child: const Text('Register now'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
