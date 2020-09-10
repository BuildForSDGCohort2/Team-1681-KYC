import 'dart:convert';
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyc_client/db/databaseProvider.dart';
import 'package:kyc_client/models/user.dart';
import 'package:kyc_client/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdditionalInfoPage extends StatefulWidget {
  final String phone;
  final String countrycode;
  final String country;
  AdditionalInfoPage({this.phone, this.countrycode, this.country});
  @override
  State<StatefulWidget> createState() {
    return _AdditionalInfoPageState();
  }
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  DatabaseProvider api;
  int _currentStep = 0;
  bool _obscureText = true;
  bool _isLoading = false;
  File _selectedImage;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Map<String, String> _formData = {
    'password': null,
    'firstname': null,
    'lastname': null,
    'email': null,
    'country': null,
    'state': null,
    'street': null,
    'avartar': null,
  };
  bool _passwordError = true,
      _firstnameError = true,
      _lastnameError = true,
      _emailError = true,
      _countryError = true,
      _locationStateError = true,
      _streetError = true,
      _profilePicError = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _formData['phone'] = widget.phone;
      _countryController.text = widget.country;
      _formData['country'] = _countryController.text;
    });
  }

  var _passwordState = StepState.indexed;
  var _nameState = StepState.indexed;
  var _emailState = StepState.indexed;
  var _addressState = StepState.indexed;
  var _profilePicState = StepState.indexed;

  final scaffoldState = GlobalKey<ScaffoldState>();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final _streetFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Please Pick /Take an Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Use Camera'),
                      ],
                    ),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    }),
                FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        SizedBox(
                          width: 10,
                        ),
                        Text('From Gallery'),
                      ],
                    ),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    }),
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File imageFile = await ImagePicker.pickImage(source: source, maxWidth: 400);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _selectedImage = croppedFile;
      _formData['avartar'] = _selectedImage != null
          ? base64Encode(_selectedImage.readAsBytesSync())
          : '';
      if (_selectedImage == null) {
        _profilePicError = true;
        _profilePicState = StepState.error;
      } else {
        _profilePicError = false;
        _profilePicState = StepState.complete;
      }
    });
    Navigator.pop(context);
  }

  Widget _buildpasswordTextFormField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      obscureText: _obscureText,
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(
          Icons.lock,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password should be at least 6 charatcers';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['password'] = value;
        if (_passwordController.text.length < 6) {
          setState(() {
            _passwordError = true;
            _passwordState = StepState.error;
          });
        } else {
          setState(() {
            _passwordError = false;
            _passwordState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildconfirmpasswordTextFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureText,
      focusNode: _confirmPasswordFocusNode,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        prefixIcon: Icon(
          Icons.lock,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value != _passwordController.text) {
          return 'Passwords not matching';
        }
        return null;
      },
      onChanged: (String value) {
        if (value.length < 6 || value != _passwordController.text) {
          setState(() {
            _passwordError = true;
            _passwordState = StepState.error;
          });
        } else {
          setState(() {
            _passwordError = false;
            _passwordState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildFirstNameTextFormField() {
    return TextFormField(
      focusNode: _firstNameFocusNode,
      controller: _firstNameController,
      decoration: InputDecoration(
        hintText: 'First Name',
        prefixIcon: Icon(
          Icons.person,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'Firstname should be at least 2 charatcers';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['firstname'] = value;
        if (_firstNameController.text.length < 2) {
          setState(() {
            _firstnameError = true;
            _nameState = StepState.error;
          });
        } else {
          setState(() {
            _firstnameError = false;
            _nameState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildLastNameTextFormField() {
    return TextFormField(
      focusNode: _lastNameFocusNode,
      controller: _lastNameController,
      decoration: InputDecoration(
        hintText: 'Last Name',
        prefixIcon: Icon(
          Icons.person,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'Lastname should be at least 2 charatcers';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['lastname'] = value;
        if (_lastNameController.text.length < 2) {
          setState(() {
            _lastnameError = true;
            _nameState = StepState.error;
          });
        } else {
          setState(() {
            _lastnameError = false;
            _nameState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildEmailTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: 'Email',
      ),
      validator: (value) {
        if (value.isEmpty || !EmailValidator.validate(value)) {
          return 'Email should be at least 2 charatcers';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['email'] = value;
        if (value.length < 2 || !EmailValidator.validate(value)) {
          setState(() {
            _emailError = true;
            _emailState = StepState.error;
          });
        } else {
          setState(() {
            _emailError = false;
            _emailState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildCountryTextFormField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CountryListPick(
          isShowFlag: true,
          isShowTitle: false,
          isShowCode: false,
          isDownIcon: true,
          initialSelection: widget.countrycode,
          showEnglishName: true,
          onChanged: (code) {
            setState(() {
              _countryController.text = code.name;
              _formData['country'] = _countryController.text;
              _countryError = false;
            });
          },
        ),
        Text(_countryController.text),
      ],
    );
  }

  Widget _buildStateTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      focusNode: _stateFocusNode,
      controller: _stateController,
      decoration: InputDecoration(
        hintText: 'Sate/District',
        prefixIcon: Icon(Icons.home),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'State should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['state'] = value;
        if (value.length < 2) {
          setState(() {
            _locationStateError = true;
            _addressState = StepState.error;
          });
        } else {
          setState(() {
            _locationStateError = false;
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildStreetTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      focusNode: _streetFocusNode,
      controller: _streetController,
      decoration: InputDecoration(
        hintText: 'Street',
        prefixIcon: Icon(
          Icons.streetview,
        ),
      ),
      validator: (street) {
        if (street.isEmpty || street.length < 2) {
          return 'Street should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String street) {
        _formData['street'] = street;
        if (street.length < 2) {
          setState(() {
            _streetError = true;
            _addressState = StepState.error;
          });
        } else {
          setState(() {
            _streetError = false;
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildProfilePicImageField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openImagePicker(context);
      },
      child: Row(
        children: [
          _selectedImage == null
              ? Image.asset(
                  'assets/images/placeholder.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  _selectedImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
        ],
      ),
    );
  }

  bool inputValid() {
    if (_passwordError ||
        _firstnameError ||
        _lastnameError ||
        _emailError ||
        _countryError ||
        _locationStateError ||
        _streetError ||
        _profilePicError) {
      return false;
    }
    return true;
  }

  // void _submitForm(datamodel) async {
  void _submitForm() async {
    // if (!_formKey.currentState.validate()) {
    //   _scaffoldKey.currentState.showSnackBar(
    //     SnackBar(
    //       content: Text('You have invalid inputs'),
    //     ),
    //   );
    // } else {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   final additionalInfoSuccess = await datamodel.registerUser(_formData);
    //   // Change Loading State
    //   setState(
    //     () {
    //       _isLoading = false;
    //     },
    //   );

    //   if (additionalInfoSuccess.containsKey('data')) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          // setSharedPreferences(User.fromJson(additionalInfoSuccess['data']));
          return _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : HomeScreen();
        },
      ),
    );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Account Error'),
    //         content: Text(additionalInfoSuccess['error']),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Okay'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     },
    //   );
    // }
    // }

    // widget.loginUser(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF00B686),
            Color(0xFF00838F),
          ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Additional Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Consumer<DatabaseProvider>(
                    builder: (context, model, child) {
                  return Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Stepper(
                      steps: _detailStepper(context),
                      type: StepperType.vertical,
                      physics: ClampingScrollPhysics(),
                      currentStep: this._currentStep,
                      onStepTapped: (step) {
                        setState(
                          () {
                            this._currentStep = step;
                          },
                        );
                      },
                      onStepContinue: () {
                        setState(
                          () {
                            if (this._currentStep <
                                this._detailStepper(context).length - 1) {
                              this._currentStep = this._currentStep + 1;
                            } else {
                              // _submitForm(model);
                              _submitForm();
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(builder: (context) {
                              //     return ChangeNotifierProvider<DatabaseProvider>(
                              //       create: (context) => DatabaseProvider.db,
                              //       child: HomeScreen(),
                              //     );
                              //   }),
                              // );
                            }
                          },
                        );
                      },
                      onStepCancel: () {
                        setState(
                          () {
                            if (this._currentStep > 0) {
                              this._currentStep -= 1;
                            } else {
                              this._currentStep = 0;
                            }
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Step> _detailStepper(BuildContext context) {
    List<Step> _steps = [
      Step(
        title: Text('Security'),
        content: Column(
          children: <Widget>[
            _buildpasswordTextFormField(),
            SizedBox(height: 10),
            _buildconfirmpasswordTextFormField(),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _passwordState,
      ),
      Step(
        title: Text('Name'),
        content: Column(
          children: <Widget>[
            _buildFirstNameTextFormField(),
            SizedBox(height: 10),
            _buildLastNameTextFormField(),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _nameState,
      ),
      Step(
        title: Text('Email'),
        content: Column(
          children: <Widget>[
            _buildEmailTextFormField(),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _emailState,
      ),
      Step(
        title: Text('Address'),
        content: Column(
          children: <Widget>[
            _buildCountryTextFormField(),
            SizedBox(height: 10),
            _buildStateTextFormField(),
            SizedBox(height: 10),
            _buildStreetTextFormField(),
          ],
        ),
        isActive: _currentStep >= 3,
        state: _emailState,
      ),
      Step(
        title: Text('Avartar'),
        content: Column(
          children: <Widget>[
            _buildProfilePicImageField(context),
          ],
        ),
        isActive: _currentStep >= 4,
        state: _addressState,
      ),
    ];
    return _steps;
  }

  setSharedPreferences(User authenticatedUser) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', authenticatedUser.email);
    pref.setString('userid', authenticatedUser.userId);
    pref.setString('usercode', authenticatedUser.usercode);
    pref.setString('firstname', authenticatedUser.firstname);
    pref.setString('lastname', authenticatedUser.lastname);
    pref.setString('token', authenticatedUser.token);
  }
}
