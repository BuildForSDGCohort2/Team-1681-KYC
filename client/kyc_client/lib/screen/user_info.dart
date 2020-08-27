import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:kyc_client/db/databaseProvider.dart';
import 'package:kyc_client/models/user.dart';
import 'package:kyc_client/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdditionalInfoPage extends StatefulWidget {
  final String phone;
  AdditionalInfoPage({this.phone});
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {
    'password': null,
    'firstname': null,
    'lastname': null,
    'email': null,
    'address': null,
  };
  bool passwordError = true,
      firstnameError = true,
      lastnameError = true,
      emailError = true,
      addressError = true,
      profilePicError = true;

  @override
  void initState() {
    super.initState();
    _formData['phone'] = widget.phone;
  }

  var _passwordState = StepState.indexed;
  var _nameState = StepState.indexed;
  var _emailState = StepState.indexed;
  var _addressState = StepState.indexed;
  var _profilePicState = StepState.indexed;

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final _passwordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Widget _buildpasswordTextFormField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
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
        if (_passwordController.text.length < 2) {
          setState(() {
            passwordError = true;
            _passwordState = StepState.error;
          });
        } else {
          passwordError = false;
          setState(() {
            _passwordState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildconfirmpasswordTextFormField() {
    return TextFormField(
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
        if (value.length < 2) {
          setState(() {
            passwordError = true;
            _passwordState = StepState.error;
          });
        } else {
          passwordError = false;
          setState(() {
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
            firstnameError = true;
            _nameState = StepState.error;
          });
        } else {
          firstnameError = false;
          setState(() {
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
            lastnameError = true;
            _nameState = StepState.error;
          });
        } else {
          lastnameError = false;
          setState(() {
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
          return 'email should be at least 2 charatcers';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['email'] = value;
        if (value.length < 2 ||
            (value.length > 2 && !EmailValidator.validate(value))) {
          setState(() {
            emailError = true;
            _emailState = StepState.error;
          });
        } else {
          emailError = false;
          setState(() {
            _emailState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildCountryTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      focusNode: _addressFocusNode,
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'Country',
        prefixIcon: Icon(
          Icons.phone,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'Country should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['country'] = value;
        if (value.length != 10) {
          setState(() {
            addressError = true;
            _addressState = StepState.error;
          });
        } else {
          addressError = false;
          setState(() {
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildStateTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      focusNode: _addressFocusNode,
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'Sate/District',
        prefixIcon: Icon(
          Icons.phone,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'State should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['state'] = value;
        if (value.length != 10) {
          setState(() {
            addressError = true;
            _addressState = StepState.error;
          });
        } else {
          addressError = false;
          setState(() {
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildStreetTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      focusNode: _addressFocusNode,
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'Street',
        prefixIcon: Icon(
          Icons.phone,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'Street should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['street'] = value;
        if (value.length != 10) {
          setState(() {
            addressError = true;
            _addressState = StepState.error;
          });
        } else {
          addressError = false;
          setState(() {
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  Widget _buildProfilePicImageField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      focusNode: _addressFocusNode,
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'Street',
        prefixIcon: Icon(
          Icons.phone,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value.length < 2) {
          return 'Street should be at least 2 characters long';
        }
        return null;
      },
      onChanged: (String value) {
        _formData['street'] = value;
        if (value.length != 10) {
          setState(() {
            addressError = true;
            _addressState = StepState.error;
          });
        } else {
          addressError = false;
          setState(() {
            _addressState = StepState.complete;
          });
        }
      },
    );
  }

  bool inputValid() {
    if (passwordError ||
        firstnameError ||
        lastnameError ||
        emailError ||
        addressError) {
      return false;
    }
    return true;
  }

  // void _submitForm() async {
  //   if (!inputValid() || !_formKey.currentState.validate()) {
  //     print('Error Occured');
  //     // Scaffold.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text('You have invalid inputs'),
  //     //   ),
  //     // );
  //   }
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final additionalInfoSuccess = await api.registerUser(User(
  //     phone: _formData['phone'],
  //     email: _formData['email'],
  //     firstname: _formData['firstname'],
  //     lastname: _formData['lastname'],
  //     password: _formData['password'],
  //     address: _formData['address'],
  //   ));
  //   // Change Loading State
  //   setState(
  //     () {
  //       _isLoading = false;
  //     },
  //   );

  //   if (additionalInfoSuccess.containsKey('data')) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) {
  //           // setSharedPreferences(User.fromJson(additionalInfoSuccess['data']));
  //           return _isLoading
  //               ? Center(
  //                   child: CircularProgressIndicator(),
  //                 )
  //               : HomeScreen();
  //         },
  //       ),
  //     );
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Account Error'),
  //           content: Text(additionalInfoSuccess['error']),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Okay'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     );
  //   }

  //   // widget.loginUser(context, user);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Information'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: Stepper(
          steps: _detailStepper(),
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
                if (this._currentStep < this._detailStepper().length - 1) {
                  this._currentStep = this._currentStep + 1;
                } else {
                  // _submitForm();
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
      ),
    );
  }

  List<Step> _detailStepper() {
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
        state: _nameState,
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
        isActive: _currentStep >= 2,
        state: _emailState,
      ),
      Step(
        title: Text('Avartar'),
        content: Column(
          children: <Widget>[
            _buildProfilePicImageField(),
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
