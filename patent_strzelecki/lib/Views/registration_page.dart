import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patent_strzelecki/Service/auth.dart';
import 'package:patent_strzelecki/Service/forgot_Password.dart';
import 'package:patent_strzelecki/Views/home_page.dart';
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
      } else {
        userCredential =
            await _auth.signUp(_emailController.text, _passwordController.text);
        _auth.sendVerificationEmail(userCredential);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLogin', true);

        User user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance.collection('account').doc(user.uid).set({
          'username': user.email?.split('@')[0],
        });

        if (!mounted) return; // Check if the widget is still mounted
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Błąd autoryzacji';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Ten adres jest już w użyciu.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Hasło jest zbyt słabe.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Błędne dane'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    if (mounted) {
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
                      'Assets/images/shooter.png', // Ensure the image exists
                      height: 150,
                      width: 150,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || !EmailValidator.validate(value)) {
                          return 'Wprowadź prawidłowy adres email.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adres email',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Hasło musi składać się z conajmniej 7 znaków.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Hasło',
                      ),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != _passwordController.text) {
                            return 'Hasła nie pasują do siebie.';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Potwierdź hasło',
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
                                'Zapomniałeś hasła?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 71, 24, 80),
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
                            backgroundColor: Color.fromARGB(255, 32, 31, 31),
                            minimumSize: Size(300, 70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5),
                        onPressed: _submit,
                        child: Text(
                          _isLogin ? 'Zaloguj' : 'Zarejestruj',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Stwórz nowe konto'
                            : 'Mam już konto',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 87, 23, 98),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(
                          'kontynuuj przy użyciu',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                Auth().signInWithGoogle();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'Assets/images/google.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () async {
                                Auth().signInWithApple();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'Assets/images/apple.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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
