import 'package:audre/models/user_model.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/user_api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  User? user = FirebaseUserProvider.getUser();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedGender = 'Male';

  List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];
  bool isUpdate = false;
  DateTime? _dob;
  String? profilePictureUrl;
  File? _pickedImage;
  bool isUsernameAvailable = true;
  bool isLoading = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  getUser() async {
    User? userData = FirebaseUserProvider.getUser();
    UserModal? user = await UserProvider.getUser();

    print(user?.toLocalString());
    if (userData != null) {
      _emailController.text = userData.email!;
    }
    if (user != null) {
      DateTime dob = DateTime.fromMicrosecondsSinceEpoch(int.parse(user.dob!));
      setState(() {
        isUpdate = true;
        _nameController.text = user.name!;
        _usernameController.text = user.username!;
        _introController.text = user.intro!;
        profilePictureUrl = user.profile_pic;
        selectedGender = user.gender ?? 'Male';
        _dob = DateTime.fromMicrosecondsSinceEpoch(int.parse(user.dob!));
        _dobController.text = '${dob.year}-${dob.month}-${dob.day}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkuserName(name) async {
    final result = await UserApiServices.checkUsernameAvailability(
        username: name, uid: user!.uid);

    setState(() {
      isUsernameAvailable = (result['message'] != 'Username already exist');
    });
  }

  // upload image to firebase storage
  Future<void> _uploadImage() async {
    try {
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 1");
      final storage = FirebaseStorage.instance;
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 2");
      final ref = storage
          .ref()
          .child('profile_picture')
          .child('${user!.uid}/picture.png');
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 3");
      await ref.putFile(_pickedImage!);
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 4");
      final url = await ref.getDownloadURL();
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 5");
      print('URL: $url');
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 6");
      setState(() {
        profilePictureUrl = url;
      });
      print("DEBUGGING UPLOADING IMAGE: CHECKPOINT 7");
    } catch (e) {
      print("ERROR OCCURED WHILE UPLOADING IMAGE");
      print(e);
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: const Color.fromARGB(255, 209, 209, 209),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // Handle image selection
                    _pickImage();
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: profilePictureUrl != null
                          ? DecorationImage(
                              image: Image.network(profilePictureUrl!).image,
                              fit: BoxFit.fill)
                          : (_pickedImage != null
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    _pickedImage!,
                                  ))
                              : null),
                    ),
                    child: _pickedImage == null
                        ? const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white70,
                            size: 100,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    checkuserName(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (!isUsernameAvailable) {
                      return 'Username is already taken';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Gender Radio Buttons
                SizedBox(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender,
                              style: const TextStyle(
                                color: Colors.white,
                              )));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                    dropdownColor: Colors.grey[900],
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[900],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _introController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Intro',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an intro';
                    }

                    if (value.length > 120) {
                      return 'Must be less then 150 character';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dobController,
                  style: const TextStyle(color: Colors.white),
                  onTap: () {
                    _showDialog(
                      CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _dob,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _dob = newDate;
                            _dobController.text =
                                newDate.toString().split(' ')[0];
                          });
                        },
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Date of Birth',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    // age must be greater than 13
                    if (DateTime.now().difference(_dob!).inDays < 4745) {
                      return 'You must be at least 13 years old';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Implement image selection functionality here
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      if (!kIsWeb) {
                        await _uploadImage();
                      }
                      print('profilePictureUrl: $profilePictureUrl');
                      UserApiServices.createUserProfile(body: {
                        'name': _nameController.text,
                        'gender': selectedGender,
                        'username': _usernameController.text,
                        'intro': _introController.text,
                        'email': _emailController.text,
                        'profile_pic': profilePictureUrl,
                        'uid': user!.uid,
                        'dob': _dob.toString().split(' ')[0],
                      });
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 116, 116, 116),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isUpdate ? 'Update Profile' : 'Create Profile',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
