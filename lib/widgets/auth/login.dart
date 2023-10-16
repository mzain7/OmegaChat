import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omega_chat/widgets/auth/password_reset.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.toggleAuthScreen});

 final void Function() toggleAuthScreen;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  final _form = GlobalKey<FormState>();

  Future<void> signInWithEmailAndPassword() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(userCredential);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Logined in successfully ${userCredential.user?.displayName}'),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),));
      // Fluttertoast.showToast(
      //     msg: "Logged In: ${userCredential.user?.displayName}");
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed. Please try again.'),
        ),
      );
      // Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email Address'),
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
              onSaved: (value) {
                _email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (context) => const PasswordReset(),);
              },
              child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blue),
                    ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                signInWithEmailAndPassword();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Text('Don\'t have an account?'),
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
          ],
        ),
      ),
    );
  }
}
