import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omega_chat/utils/styles.dart';
import 'package:omega_chat/widgets/auth/password_reset.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.toggleAuthScreen});

  final void Function() toggleAuthScreen;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  Future<void> signInWithEmailAndPassword() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
      return;
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      print(userCredential);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Logined in successfully ${userCredential.user?.displayName}'),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color.fromARGB(117, 46, 46, 48),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WELCOME!',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  autovalidateMode: _autovalidateMode,
                  decoration: textFieldStyle.copyWith(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordController,
                  autovalidateMode: _autovalidateMode,
                  decoration: textFieldStyle.copyWith(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PasswordReset(email: _emailController.text),
                    );
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 244, 161, 31),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 12.0),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      signInWithEmailAndPassword();
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleAuthScreen();
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
