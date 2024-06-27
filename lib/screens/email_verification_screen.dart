import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcq/responsive/mobile_screen_layout.dart';
import 'package:hcq/responsive/responsive_layout_screen.dart';
import 'package:hcq/responsive/web_screen_layout.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/utils.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool isLoading = false;
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    setState(() {
      isEmailVerified = user.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      await user.sendEmailVerification();
      setState(() {
        isLoading = false;
      });
      showSnackBar("Verification email sent", context);
    } catch (e) {
      showSnackBar(
          "Error sending verification email: ${e.toString()}", context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'A verification email has been sent to your email address. Please verify your email to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              if (isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: resendVerificationEmail,
                  child: const Text(
                    'Resend Verification Email',
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: checkEmailVerified,
                child: const Text('I have verified my email',
                    style: TextStyle(color: secondaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
