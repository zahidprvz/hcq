import 'package:flutter/material.dart';
import 'package:hcq/responsive/mobile_screen_layout.dart';
import 'package:hcq/responsive/responsive_layout_screen.dart';
import 'package:hcq/responsive/web_screen_layout.dart';
import 'package:hcq/screens/signup_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/utils/utils.dart';
import 'package:hcq/widgets/text_field_input.dart';
import 'package:hcq/resources/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isLoading = false;
  bool _isCodeSent = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verificationCodeController.dispose();
  }

  void sendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().sendVerificationCode(
      email: _emailController.text,
    );

    if (res == 'success') {
      setState(() {
        _isCodeSent = true;
      });
      showSnackBar('Verification code sent to your email', context);
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      sendVerificationCode();
    } else {
      showSnackBar(res, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void verifyCodeAndLogin() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().verifyCode(
      email: _emailController.text,
      code: _verificationCodeController.text,
    );

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                  )
                : const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            color: mobileBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64.0,
                ),
                // Logo
                Image.asset(
                  'assets/HCQ.png',
                  height: 250.0,
                ),
                const SizedBox(
                  height: 64.0,
                ),
                // Email textfield
                TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                // Password textfield
                TextFieldInput(
                  hintText: 'Enter your password',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                // Button
                InkWell(
                  onTap: _isCodeSent ? verifyCodeAndLogin : loginUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text(
                            _isCodeSent ? 'Verify Code' : 'Login',
                            style: const TextStyle(color: primaryColor),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                if (_isCodeSent)
                  TextFieldInput(
                    hintText: 'Enter the verification code',
                    textEditingController: _verificationCodeController,
                    textInputType: TextInputType.number,
                  ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: const Text("Don't have an account?"),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 64.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
