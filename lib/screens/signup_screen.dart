import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hcq/resources/auth_methods.dart';
import 'package:hcq/responsive/mobile_screen_layout.dart';
import 'package:hcq/responsive/responsive_layout_screen.dart';
import 'package:hcq/responsive/web_screen_layout.dart';
import 'package:hcq/screens/login_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/utils/utils.dart';
import 'package:hcq/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime? _selectedDate;
  Uint8List? _image;
  bool _isLoading = false;
  bool _userAgreementAccepted = false;
  bool _privacyPolicyAccepted = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void signUpUser() async {
    if (!_userAgreementAccepted || !_privacyPolicyAccepted) {
      showSnackBar('Please accept User Agreement and Privacy Policy', context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      dateOfBirth: _selectedDate,
      gender: _genderController.text,
      phone: _phoneController.text,
      file: _image,
      userAgreementAccepted: _userAgreementAccepted,
      privacyPolicyAccepted: _privacyPolicyAccepted,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
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

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  void showGenderPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Select Gender'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Male'),
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Male';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Female'),
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Female';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Prefer not to say'),
                  onTap: () {
                    setState(() {
                      _genderController.text = 'Prefer not to say';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                const SizedBox(height: 16.0),
                Image.asset(
                  'assets/HCQ.png',
                  height: 200.0,
                ),
                const SizedBox(height: 14.0),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64.0,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64.0,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                    Positioned(
                      bottom: -10.0,
                      left: 80.0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                TextFieldInput(
                  hintText: 'Enter your username',
                  textEditingController: _usernameController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24.0),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24.0),
                TextFieldInput(
                  hintText: 'Enter your password',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select your date of birth'
                              : 'DOB: ${_selectedDate!.toLocal()}'
                                  .split(' ')[0],
                          style: const TextStyle(
                              fontSize: 16.0, color: secondaryColor),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: showGenderPickerDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      _genderController.text.isEmpty
                          ? 'Select Gender (Optional)'
                          : 'Gender: ${_genderController.text}',
                      style: const TextStyle(color: secondaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFieldInput(
                  hintText: 'Enter your phone number (optional)',
                  textEditingController: _phoneController,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Checkbox(
                      value: _userAgreementAccepted,
                      onChanged: (value) {
                        setState(() {
                          _userAgreementAccepted = value!;
                        });
                      },
                    ),
                    const Text('I agree to the User Agreement'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _privacyPolicyAccepted,
                      onChanged: (value) {
                        setState(() {
                          _privacyPolicyAccepted = value!;
                        });
                      },
                    ),
                    const Text('I agree to the Privacy Policy'),
                  ],
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Your data is safe with us. We do not share your information with any third party.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(color: primaryColor),
                          ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
