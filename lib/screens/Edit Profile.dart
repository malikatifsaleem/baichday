import 'dart:io';

import 'package:baichday/components/custom_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/validators.dart';
import '../constants/widgets.dart';
import '../services/auth.dart';
import '../services/user.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ValidateService _validateService  = new ValidateService();
  // ProfileService _profileService = new ProfileService();
  UserService _userService = new UserService();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool showCartIcon = true;
  bool _autoValidate = false;
  String? fullName, mobileNumber, email;
  bool obsecure = true;
  Auth authService = Auth();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  File? _imageFile;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Autofill the fields with user details
    _autofillUserDetails();
  }

  void _autofillUserDetails() async{
    // Retrieve user details from Firebase Authentication
    User? currentUser = auth.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final QuerySnapshot userDataQuery =
        await users.where('uid', isEqualTo: currentUser!.uid).get();

    if (userDataQuery != null) {
      _firstNameController.text = userDataQuery.docs.first['name']?.split(' ')[0] ?? '';
      _lastNameController.text = userDataQuery.docs.first['name']?.split(' ')[1] ?? '';
      _emailController.text = userDataQuery.docs.first['email'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Edit Profile')),
        // drawer: sidebar(context),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 60,
                          child: CircleAvatar(
                            backgroundColor: secondaryColor,
                            radius: 70,
                            // child: _imageFile != null
                            //     ? ClipOval(
                            //   child: Image.file(
                            //     _imageFile!,
                            //     fit: BoxFit.cover,
                            //     width: 160,
                            //     height: 160,
                            //   ),
                            // )
                            //     : widget.user.images != "" &&
                            //     widget.user.images.isNotEmpty
                            //     ? ClipOval(
                            //   child: Image.network(
                            //     widget.user.images,
                            //     fit: BoxFit.cover,
                            //     width: 160,
                            //     height: 160,
                            //   ),
                            // )
                            //     :
                            child: Icon(
                              CupertinoIcons.person,
                              color: whiteColor,
                              size: 50,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _firstNameNode,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'first name');
                            },
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                hintText: 'Enter your First Name',
                                hintStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _lastNameNode,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'last name');
                            },
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                hintText: 'Enter your Last Name',
                                hintStyle: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _emailNode,
                      controller: _emailController,
                      validator: (value) {
                        return validateEmail(value,
                            EmailValidator.validate(_emailController.text));
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ])),
            )
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          // elevation: 16,
          child: roundedButton(
              context: context,
              bgColor: secondaryColor,
              text: 'Update',
              textColor: whiteColor,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String firstName = _firstNameController.text.trim();
                  String lastName = _lastNameController.text.trim();
                  String email = _emailController.text.trim();
                  // String password = _passwordController.text.trim();

                  try {
                    // Call the updateProfile method from Auth service
                    await authService.updateProfile(
                      uid:
                          auth.currentUser!.uid, // Replace with actual user UID
                      name: '$firstName $lastName',
                      email: email, context: context,
                      // You may include mobile number, address, etc.
                    );

                    // Show success message or navigate to another screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  } catch (error) {
                    // Handle errors here
                    print('Error updating profile: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update profile'),
                      ),
                    );
                  }
                }
              }),
        ));
  }
}
