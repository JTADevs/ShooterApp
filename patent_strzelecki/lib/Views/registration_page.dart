import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:patent_strzelecki/Service/auth.dart';
import 'package:patent_strzelecki/Service/forgot_Password.dart';
import 'package:patent_strzelecki/Views/setup_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Auth _auth = Auth();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  var _isLogin = true;
  var _isAuthenticating = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isAuthenticating = true;
    });

    try {
      if (!_isLogin &&
          _passwordController.text != _confirmPasswordController.text) {
        throw FirebaseAuthException(
          code: 'passwords-do-not-match',
          message: 'Passwords do not match.',
        );
      }
      UserCredential userCredential;
      if (_isLogin) {
        userCredential =
            await _auth.signIn(_emailController.text, _passwordController.text);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        userCredential =
            await _auth.signUp(_emailController.text, _passwordController.text);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLogin', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SetupProfilePage()));
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'Assets/images/shooter.png', // Upewnij się, że obraz jest dostępny
                      height: 150, // Wysokość obrazu
                      width: 150, // Szerokość obrazu
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || !EmailValidator.validate(value)) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    if (!_isLogin) // Tylko przy rejestracji dodajemy pole potwierdzenia hasła
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != _passwordController.text) {
                            return 'Passwords must match.';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                      ),
                    if (_isLogin)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ForgotPasswordPage();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 71, 24, 80), // Purple color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (_isAuthenticating) CircularProgressIndicator(),
                    if (!_isAuthenticating)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color.fromARGB(255, 32, 31, 31), // foreground
                            minimumSize: Size(300, 70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5),
                        onPressed: _submit,
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Pogrubienie tekstu
                            fontSize: 16,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        // Resetuje stan formularza, czyści wszystkie bieżące błędy walidacji
                        _formKey.currentState?.reset();
                        // Czyści wartości kontrolerów
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        style: TextStyle(
                            color: const Color.fromARGB(255, 87, 23, 98),
                            fontWeight: FontWeight.bold),
                        _isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20), // Odstęp dla estetyki
                        Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20), // Odstęp dla estetyki
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                Auth().signInWithGoogle();
                              },
                              // Dodaj tutaj logikę logowania przez Google

                              child: Container(
                                padding: const EdgeInsets.all(
                                    8), // Padding wokół logo
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Kształt okręgu
                                  color: Colors.white, // Tło białe
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'Assets/images/google.png', // Upewnij się, że obraz jest dostępny
                                  height: 50, // Wysokość obrazu
                                  width: 50, // Szerokość obrazu
                                ),
                              ),
                            ),
                            const SizedBox(width: 30), // Przerwa między ikonami
                            GestureDetector(
                              onTap: () async {
                                Auth().signInWithApple();
                                // Dodaj tutaj logikę logowania przez Apple
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                    8), // Padding wokół logo
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Kształt okręgu
                                  color: Colors.white, // Tło białe
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'Assets/images/apple.png', // Upewnij się, że obraz jest dostępny
                                  height: 50, // Wysokość obrazu
                                  width: 50, // Szerokość obrazu
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30), // Odstęp na dole
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
