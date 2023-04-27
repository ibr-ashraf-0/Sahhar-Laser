import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Resetpsw extends StatefulWidget {
  @override
  ResetpswPageState createState() => ResetpswPageState();
}

class ResetpswPageState extends State<Resetpsw> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.sendPasswordResetEmail(email: email.text);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildAlertDialog(email.text);
                      },
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  // height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E0000).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAlertDialog(String email) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text(
        "Reset Password Success",
        style: TextStyle(
          fontSize: 24,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text(
          "We will send An email to: $email To reset your password.\n please cheack your email",
        ),
      ),
      actions: <Widget>[
        InkWell(
          child: const Text(
            "OK",
            style: TextStyle(
              fontSize: 22,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
