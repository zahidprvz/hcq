import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hcq/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hcq/widgets/text_field_input.dart';

class ProfileCustomizationWidget extends StatefulWidget {
  const ProfileCustomizationWidget({Key? key}) : super(key: key);

  @override
  _ProfileCustomizationWidgetState createState() =>
      _ProfileCustomizationWidgetState();
}

class _ProfileCustomizationWidgetState
    extends State<ProfileCustomizationWidget> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  DateTime? _selectedDate;

  String _profileImageUrl = '';
  File? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _usernameController.text = snapshot.data()?['username'] ?? '';
          _phoneController.text = snapshot.data()?['phone'] ?? '';
          _genderController.text = snapshot.data()?['gender'] ?? '';
          _selectedDate =
              (snapshot.data()?['dateOfBirth'] as Timestamp?)?.toDate();
          _profileImageUrl = snapshot.data()?['photoUrl'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _loading = true;
      });

      try {
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await _uploadImageToStorage(user.uid);
        }

        Map<String, dynamic> updatedData = {
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'gender': _genderController.text,
          'dateOfBirth': _selectedDate,
        };

        if (imageUrl != null && imageUrl.isNotEmpty) {
          updatedData['photoUrl'] = imageUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updatedData);

        Fluttertoast.showToast(msg: 'Profile updated successfully');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to update profile: $e');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<String> _uploadImageToStorage(String uid) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = uid + '_profile.jpg';
      Reference reference = storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = reference.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  void _deleteUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        await user.delete();
        Fluttertoast.showToast(msg: 'User profile deleted successfully');
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to delete user profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Profile Customization'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
              color: secondaryColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : _profileImageUrl.isNotEmpty
                                ? NetworkImage(_profileImageUrl)
                                    as ImageProvider
                                : null,
                        child: _imageFile == null && _profileImageUrl.isEmpty
                            ? const Icon(Icons.add_a_photo,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      hintText: 'Enter your username',
                      textEditingController: _usernameController,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      hintText: 'Enter your phone number (optional)',
                      textEditingController: _phoneController,
                      textInputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text("Delete Account:"),
                              IconButton(
                                onPressed: _deleteUserProfile,
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          TextButton.icon(
                            onPressed: _updateUserProfile,
                            icon: const Icon(Icons.save),
                            label: const Text('Update'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: secondaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
