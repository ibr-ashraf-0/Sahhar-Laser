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
        title: Text(
          'Reset password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
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
              SizedBox(height: 20),
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
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
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
          "An email has been sent to : $email To reset your password.",
        ),
      ),
      actions: <Widget>[
        InkWell(
          child: Text(
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
