import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hcq/resources/auth_methods.dart';
import 'package:hcq/screens/email_verification_screen.dart';
import 'package:hcq/screens/login_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/utils/utils.dart';
import 'package:hcq/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime? _selectedDate;
  Uint8List? _image;
  bool _isLoading = false;
  bool _userAgreementAccepted = false;
  bool _privacyPolicyAccepted = false;
  String? _phoneNumber;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneNumber == null ||
        _phoneNumber!.isEmpty ||
        !_userAgreementAccepted ||
        !_privacyPolicyAccepted) {
      showSnackBar(
          'Please fill all the required fields and accept agreements', context);
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
      phone: _phoneNumber!,
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
          builder: (context) => const EmailVerificationScreen(),
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

  void showTermsOfUseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Terms of Use'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Colorectal Cancer\n\n"
                    "Colorectal cancer (CRC) is a significant global health concern, particularly affecting African Americans, who experience higher incidence and mortality rates compared to other racial groups. Despite advancements in medical technology and awareness campaigns, disparities in CRC screening and outcomes persist. Factors contributing to these disparities include genetics, diet, lifestyle choices, and socioeconomic status. African Americans often face late-stage diagnoses, which complicates treatment and reduces survival rates. The App emphasizes the need for targeted interventions, improved healthcare access, and increased awareness to address these disparities and promote equitable health outcomes.\n\n"
                    "The information contained in this App is not intended to replace professional medical advice. Any use of information in this APP is at the user’s discretion. Global Health Diagnostics LLC disclaims any liability arising directly or indirectly from applying any information contained herein."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: secondaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
                IntlPhoneField(
                  cursorColor: secondaryColor,
                  style: const TextStyle(),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.phone),
                    suffixIconColor: secondaryColor,
                    labelText: 'Phone Number',
                    fillColor: secondaryColor,
                    labelStyle: TextStyle(color: secondaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: secondaryColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: secondaryColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: secondaryColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  initialCountryCode: 'US',
                  onChanged: (phone) {
                    setState(() {
                      _phoneNumber = phone.completeNumber;
                    });
                  },
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Checkbox(
                      activeColor: secondaryColor,
                      value: _userAgreementAccepted,
                      onChanged: (value) {
                        setState(() {
                          _userAgreementAccepted = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: showTermsOfUseDialog,
                      child: const Text(
                        'I agree to the Terms of Use',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: secondaryColor,
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
