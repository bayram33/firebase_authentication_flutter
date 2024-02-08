import 'package:caseone/screen/home.dart';
import 'package:caseone/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool changepage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: changepage ? buildSignInForm() : buildRegisterForm(),
      ),
    );
  }

  Padding buildSignInForm() {
    final signInKey = GlobalKey<FormState>();
    TextEditingController mail = TextEditingController();
    TextEditingController password = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Giriş Yapınız"),
            const SizedBox(height: 20),
            TextFormField(
              controller: mail,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "Invalid E-mail";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: "E-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: password,
              validator: (value) {
                if (value!.length < 6) {
                  return "Longer than  6 characters please.";
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (signInKey.currentState!.validate()) {
                    await Provider.of<Auth>(context, listen: false)
                        .signInEmailAndPassword(mail.text, password.text);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  }
                },
                child: const Text("Giriş")),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  setState(() {
                    changepage = false;
                  });
                },
                child: const Text("Yeni Kayıt  Ol"))
          ],
        ),
      ),
    );
  }

  Padding buildRegisterForm() {
    final registerKey = GlobalKey<FormState>();
    TextEditingController mail = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController repassword = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: registerKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Kayıt Yapınız"),
            const SizedBox(height: 20),
            TextFormField(
              controller: mail,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "Invalid E-mail";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: "E-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: password,
              validator: (value) {
                if (value!.length < 6) {
                  return "Longer than  6 characters please.";
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: repassword,
              validator: (value) {
                if (value != password.text) {
                  return "Passwords don't match";
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                hintText: "Password Return",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (registerKey.currentState!.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                            mail.text, password.text);
                    if (!user!.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    setState(() {
                      changepage = true;
                    });
                  }
                },
                child: const Text("Kayıt")),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  setState(() {
                    changepage = true;
                  });
                },
                child: const Text("Zaten Üye misiniz"))
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Confirm your Mail.'),
                Text('After again enter the new account'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dones'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
